import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Services.Pipewire

// the overlay + popup
PanelWindow {
    id: root
    WlrLayershell.namespace: "volume-overlay"
    WlrLayershell.exclusiveZone: 0

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    margins.top: 0  // below topbar

    color: "transparent"
    visible: root.menuOpen || root.closing

    property bool menuOpen: false
    property bool closing: false

    function open() {
        closing = false
        menuOpen = true
    }

    function close() {
        if (closing) return
        closing = true
        menuOpen = false
        closeTimer.start()
        volumeID.isOpen = false
    }

    Timer {
        id: closeTimer
        interval: 250
        onTriggered: {
            root.closing = false
            menuOpen = false
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.close()

        Rectangle {
            id: menuRect
            width: 160
            height: 40
            color: theme.bg
            bottomLeftRadius: 10
            bottomRightRadius: 10
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: -2
            anchors.rightMargin: 320
            opacity: root.menuOpen ? 1 : 0

            transform: Translate {
                y: root.menuOpen ? 0 : -menuRect.height
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
                onClicked: {}
            }

            RowLayout {
                spacing: 0
                anchors.centerIn: parent

                Text { 
                    text: volumeID.volIcon
                    color: theme.text
                    Layout.preferredWidth: 20
                    font.pixelSize: theme.fontSizeLg
                }

                Slider {
                    id: volumeSlider
                    from: 0
                    to: 100
                    value: volumeID.volume
                    Layout.preferredWidth: 120
                    
                    background: Rectangle {
                        color: 'transparent'
                        implicitWidth: 120
                        implicitHeight: 15
                        radius: 2
                    }

                    Rectangle {
                        color: theme.textMuted
                        implicitWidth: 120
                        implicitHeight: 4
                        radius: 2
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    handle: Rectangle {
                        width: 16
                        height: 16
                        radius: 6
                        color: theme.accent
                        x: (parent.width - width) * parent.visualPosition
                        y: (parent.height - height) / 2
                    }

                    onMoved: {
                        volumeID.sliderVolume = value
                        Pipewire.defaultAudioSink.audio.volume = value / 100
                    }

                    Connections {
                        target: volumeID.sink?.audio
                        function onVolumeChanged() {
                            volumeSlider.value = Math.round(volumeID.sink.audio.volume * 100)
                        }
                    }
                }
            }

            // TR corner
            Canvas {
                width: 15
                height: 15
                anchors.topMargin: 2
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

            // TL corner
            Canvas {
                width: 15
                height: 15
                anchors.topMargin: 2
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