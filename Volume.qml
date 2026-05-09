import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Wayland
import Quickshell.Services.Pipewire

Item {
    id: root
    implicitWidth: volText.implicitWidth
    implicitHeight: volText.implicitHeight

    property bool isOpen: false

    signal openRequested()
    signal closeRequested()

    PwObjectTracker {
        id: tracker
        objects: [Pipewire.defaultAudioSink]
    }

    property var sink: Pipewire.defaultAudioSink
    property int volume: sink?.ready  ? Math.round((sink.audio?.volume ?? 0) * 100) : 0
    property bool muted: sink?.ready ? (sink.audio?.muted ?? false) : false

    property int sliderVolume: volume

    property string volIcon: {
        if (muted) return "󰝟"
        if (volume >= 70) return "󰕾"
        if (volume >= 30) return "󰖀"
        return "󰕿"
    }

    Rectangle {
        id: stats
        implicitWidth: 60
        color: theme.surface
        radius: theme.pillRadius
        implicitHeight: theme.pillHeight
        anchors.verticalCenter: parent.verticalCenter

        RowLayout {
            spacing: 10
            Layout.alignment: Qt.AlignRight
            anchors.verticalCenter: parent.verticalCenter

            Text {
                id: volText
                text: root.sink?.ready  ? (root.muted ? " 󰝟 muted" : ("  " + root.volume + "%  " + root.volIcon))  : "--"
                color: theme.text
                font.pixelSize: theme.fontSize

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onWheel: (event) => {
                        let audio = Pipewire.defaultAudioSink?.audio
                        if (!audio) return
                        if (event.angleDelta.y > 0)
                            audio.volume = Math.min(1.0, audio.volume + 0.02)
                        else
                            audio.volume = Math.max(0.0, audio.volume - 0.02)
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