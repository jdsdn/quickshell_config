import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

RowLayout {
    spacing: 8
    anchors.centerIn: parent

    Rectangle {
        width: 160
        height: theme.pillHeight
        radius: theme.pillRadius
        color: theme.surface
        anchors.verticalCenter: parent.verticalCenter

        Row {
            anchors.centerIn: parent
            spacing: 12 

            Repeater {
                model: 6

                Text {
                    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    property bool hasWindows: Hyprland.workspaces.values.find(w => w.id === index + 1 && w.windowCount > 0) !== undefined

                    text: ws ? "\udb82\udfaf" : "\uf10c"
                    color: isActive ? theme.bg : theme.textMuted
                    font.pixelSize: theme.fontSizeLg

                    Rectangle {
                        visible: true
                        anchors.centerIn: parent
                        width: parent.width + 10
                        height: parent.height
                        radius: theme.pillRadius
                        color: isActive ? theme.text : theme.surface
                        z: -1
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
                    }
                }
            }
        }
    }
}