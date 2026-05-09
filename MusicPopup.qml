import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Services.Mpris

PanelWindow {
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.namespace: "music-menu-overlay"

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    margins.top: 0

    visible: false
    color: "transparent"

    property real seekLength: 0
    property real seekPosition: musicWidgetID.player?.position ?? 0

    property bool closing: false
    property bool menuOpen: false
    property string currentArtUrl: ""

    function open() {
        closing = false
        menuOpen = true
        visible = true
    }

    function close() {
        if (closing) return
        closing = true
        menuOpen = false
        visible = false
        seekTimer.stop()
        closeTimer.start()
        musicWidgetID.isOpen = false
    }

    function formatTime(seconds) {
        if (!seconds) return "0:00"
        let mins = Math.floor(seconds / 60)
        let secs = Math.floor(seconds % 60)
        return mins + ":" + (secs < 10 ? "0" : "") + secs
    }

    Timer {
        id: closeTimer
        interval: 250
        onTriggered: closing = false
    }

    Timer {
        id: seekTimer
        interval: 1000
        running: visible && musicWidgetID.player?.playbackState === MprisPlaybackState.Playing
        repeat: true
        onTriggered: {
            seekPosition = musicWidgetID.player?.position ?? 0
            seekLength = musicWidgetID.player?.length ?? 0
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: close()

        Rectangle {
            id: musicPopUpRect
            width: 400
            height: 180
            color: theme.bg
            bottomLeftRadius: 10
            bottomRightRadius: 10
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 0
            anchors.leftMargin: 27
            opacity: menuOpen ? 1 : 0

            transform: Translate {
                y: menuOpen ? 0 : -musicPopUpRect.height
                Behavior on y {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            MouseArea {
                anchors.fill: parent
            }

            Timer {
                interval: 500
                running: musicWidgetID.player?.playbackState === MprisPlaybackState.Playing
                repeat: true
                onTriggered: {
                    if (musicWidgetID.player) seekSlider.value = musicWidgetID.player.position
                }
            }

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                Image {
                    id: albumArt
                    Layout.preferredWidth: 150
                    Layout.preferredHeight: 150
                    Layout.topMargin: -10
                    source: musicWidgetID.player?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    smooth: true
                    clip: true

                    Rectangle {
                        anchors.fill: parent
                        color: theme.surface
                        radius: 8
                        visible: parent.status !== Image.Ready

                        Text {
                            anchors.centerIn: parent
                            text: musicWidgetID.playerIcon
                            font.pixelSize: 48
                            color: theme.textMuted
                        }
                    }
                }


                ColumnLayout {
                    Layout.topMargin: -10
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 3

                    Text {
                        text: musicWidgetID.player?.trackTitle ?? "Not Playing"
                        color: theme.text
                        font.pixelSize: 14
                        font.bold: true
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        text: musicWidgetID.player?.trackAlbum ?? ""
                        color: theme.textMuted
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        visible: text !== ""
                        Layout.fillWidth: true
                    }

                    Text {
                        text: musicWidgetID.player?.trackArtist ?? ""
                        color: theme.textMuted
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                        elide: Text.ElideRight
                        visible: text !== ""
                        Layout.fillWidth: true
                    }

                    Item { Layout.fillHeight: true }

                    RowLayout {
                        spacing: 8
                        Layout.fillWidth: true
                        
                        Text {
                            text: formatTime(seekPosition)
                            color: theme.textMuted
                            font.pixelSize: 11
                        }
                        
                        Slider {
                            id: seekSlider
                            from: 0
                            to: musicWidgetID.player?.length ?? 1
                            value: musicWidgetID.player?.position ?? 0
                            Layout.fillWidth: true
                            
                            onMoved: musicWidgetID.player?.position(value)
                            
                            background: Rectangle {
                                color: theme.textMuted
                                implicitHeight: 4
                                radius: 2
                            }
                            handle: Rectangle {
                                width: 7
                                height: 20
                                radius: 6
                                color: theme.accent
                                x: (parent.width - width) * seekSlider.visualPosition
                                y: (parent.height - height) / 2
                            }
                        }
                        
                        Text {
                            text: formatTime(musicWidgetID.player?.length ?? 0)
                            color: theme.textMuted
                            font.pixelSize: 11
                        }
                    }

                    RowLayout {
                        spacing: 20
                        Layout.alignment: Qt.AlignHCenter
                        
                        // Previous
                        Text {
                            text: "⏮"
                            font.pixelSize: 24
                            color: theme.text
                            MouseArea {
                                anchors.fill: parent
                                onClicked: musicWidgetID.player?.previous()
                            }
                        }

                        Text {
                            text: musicWidgetID.stateIcon
                            font.pixelSize: 26
                            color: theme.text
                            MouseArea {
                                anchors.fill: parent
                                onClicked: musicWidgetID.player?.togglePlaying()
                            }
                        }

                        Text {
                            text: "⏭"
                            font.pixelSize: 24
                            color: theme.text
                            MouseArea {
                                anchors.fill: parent
                                onClicked: musicWidgetID.player?.next()
                            }
                        }
                    }
                }
            }

            //  TR corner
            Canvas {
                width: 15
                height: 15
                anchors.topMargin: 0
                anchors.rightMargin: -15
                anchors.top: parent.top
                anchors.right: parent.right
                onPaint: {
                    const ctx = getContext("2d")
                    const s = 15
                    ctx.clearRect(0, 0, s, s)
                    ctx.fillStyle = theme.bg
                    ctx.beginPath()
                    ctx.moveTo(0,s)
                    ctx.lineTo(0,0)
                    ctx.lineTo(s,0)
                    ctx.arc(s, s, s, 0, Math.PI/2, true)
                    ctx.closePath()
                    ctx.fill()
                }
            }

            Canvas {
                width: 15
                height: 15
                anchors.topMargin: 0
                anchors.leftMargin: -15
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.fill: parent
                onPaint: {
                    const ctx = getContext("2d")
                    const s = 15
                    ctx.clearRect(0, 0, s, s)
                    ctx.fillStyle = theme.bg
                    ctx.beginPath()
                    ctx.moveTo(0,0)
                    ctx.lineTo(s,0)
                    ctx.lineTo(s,s)
                    ctx.arc(0, s, s, 0, Math.PI/2, true)
                    ctx.lineTo(0,0)
                    ctx.closePath()
                    ctx.fill()
                }
            }
        }
    }
}
