import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris

Item {
    id: root
    property bool isOpen: false
    property var lastActivePlayer: null

    signal openRequested()
    signal closeRequested()

    property var player: {
        if (lastActivePlayer) return lastActivePlayer
        let players = Mpris.players.values
        if (players.length === 0) return null
        let playing = players.find(p => p.playbackState === MprisPlaybackState.Playing)
        if (playing) return playing
        let paused = players.find(p => p.playbackState === MprisPlaybackState.Paused)
        if (paused) return paused
        return players[0]
    }
    
    Repeater {
        model: Mpris.players

        Item {
            required property var modelData

            Connections {
                target: modelData
                function onPlaybackStateChanged() {
                    if (modelData.playbackState === MprisPlaybackState.Playing) {
                        root.lastActivePlayer = modelData
                    }
                }
            }
        }
    }

    property string playerIcon: {
        if (!root.player) return ""
        let id = root.player.identity.toLowerCase()
        if (id.includes("spotify")) return ""
        if (id.includes("mullvad") || id.includes("firefox") || id.includes("chrome")) return ""
        if (id.includes("vlc")) return "󰕼"
        if (id.includes("mpv")) return ""
        return ""
    }

    property string stateIcon: {
        if (!root.player) return "󰝛"
        switch (root.player.playbackState) {
            case MprisPlaybackState.Playing: return ""
            case MprisPlaybackState.Paused: return ""
            default: return ""
        }
    }

    Rectangle {
        id: menuRect
        width: 250
        height: theme.pillHeight
        radius: theme.pillRadius
        color: theme.surface
        anchors.verticalCenter: parent.verticalCenter
        clip: true

        Row {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4

            Text {
                id: staticPart
                anchors.verticalCenter: parent.verticalCenter
                text: root.player ? "   " + stateIcon + "  " : " "
                color: theme.text
                font.pixelSize: theme.fontSize

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton
                    onClicked: if (root.player) root.player.togglePlaying()
                }
            }

            // marquee — artist - title scrolls together
            Item {
                width: menuRect.width - staticPart.width - 10
                height: marqueeText.height
                clip: true
                anchors.verticalCenter: parent.verticalCenter

                Text {
                    id: marqueeText
                    text: root.player ? root.player.trackArtist + " - " + root.player.trackTitle : "No music"
                    color: theme.text
                    font.pixelSize: theme.fontSize

                    onTextChanged: {
                        x = 0
                        marqueeAnim.stop()
                        resetTimer.restart()
                    }

                    Timer {
                        id: resetTimer
                        interval: 100
                        onTriggered: {
                            if (marqueeText.implicitWidth > marqueeText.parent.width) {
                                marqueeAnim.restart()
                            }
                        }
                    }

                    SequentialAnimation on x {
                        id: marqueeAnim
                        running: marqueeText.implicitWidth > marqueeText.parent.width
                        loops: Animation.Infinite

                        PauseAnimation { duration: 3000 }

                        NumberAnimation {
                            to: -(marqueeText.implicitWidth - marqueeText.parent.width + 4)
                            duration: marqueeText.implicitWidth * 10
                            easing.type: Easing.Linear
                        }

                        PauseAnimation { duration: 2500 }

                        NumberAnimation { to: 0; duration: 0 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton
                    onWheel: (event) => {
                        if (!root.player) return
                        if (event.angleDelta.y > 0) root.player.next()
                        else root.player.previous()
                    }
                    onClicked: {
                        if (root.isOpen) {
                            root.isOpen = false
                            root.closeRequested()
                        } else {
                            root.isOpen = true
                            root.openRequested()
                        }
                    }
                }
            }
        }
    }
}
