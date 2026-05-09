import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
    spacing: 8
    Layout.alignment: Qt.AlignRight

    Item {
        id: notifItem
        implicitWidth: bellText.implicitWidth
        implicitHeight: bellText.implicitHeight

        property int unreadCount: 0
        property bool dnd: false
        property bool inhibited: false

        Process {
            id: swayncProcess
            running: true
            command: ["swaync-client", "-swb"]
            stdout: SplitParser {
                onRead: data => {
                    try {
                        let json = JSON.parse(data)
                        notifItem.unreadCount = parseInt(json.text) ?? 0
                        notifItem.dnd = json.class.includes('dnd') ?? false
                        notifItem.inhibited = json.class.includes('inhibited') ?? false
                    } catch(e) {
                        console.log("notif parse error:", e)
                    }
                }
            }

            // Component.onCompleted: running = true
            Component.onCompleted: startDetached()
        }

        Text {
            id: bellText
            text: {
                let count = notifItem.unreadCount
                if (notifItem.dnd && count) return "\uec09"
                if (notifItem.dnd) return "\uf478"
                if (count) return "\ueb9a"
                return "\uf49a"
            }
            color: theme.text
            font.pixelSize: (notifItem.unreadCount || (notifItem.dnd && notifItem.unreadCount)) ? 16 : theme.fontSize
        }

        MouseArea {
            anchors.fill: notifItem
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (event) => {
                if (event.button === Qt.RightButton)
                    Quickshell.execDetached(["swaync-client", "-d", "-sw"])
                else
                    Quickshell.execDetached(["swaync-client", "-t", "-sw"])
            }
        }
    }
}