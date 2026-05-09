import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Row {
    spacing: 6
    layoutDirection: Qt.RightToLeft

    Repeater {
        model: SystemTray.items

        delegate: Item {
            id: delegateItem
            required property var modelData
            width: 20
            height: 20

            Image {
                anchors.centerIn: parent
                source: modelData.icon
                width: 20
                height: 20
                fillMode: Image.PreserveAspectFit
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: delegateItem.modelData.menu
                anchor.window: root
                anchor.rect: {
                    let pos = delegateItem.mapToItem(null, 0, 0)
                    return Qt.rect(pos.x, pos.y, delegateItem.width, delegateItem.height)
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onClicked: (event) => {
                    if (event.button === Qt.RightButton)
                        menuAnchor.open()
                    else
                        delegateItem.modelData.activate()
                }
            }
        }
    }
}