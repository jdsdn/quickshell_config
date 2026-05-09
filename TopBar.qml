import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Hyprland

import qs as C

PanelWindow {
    id: root

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: theme.rectHeight
    color: "transparent"

    Loaders {
        id: loaders
    }

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: theme.rectHeight
        color: theme.bg

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 15
            spacing: 8

            // LEFT GROUP
            RowLayout {
                spacing: 25

                SessionMenuButton {
                    id: sessionMenuButton
                    onOpenRequested: loaders.sessionMenuLoader.open()
                    onCloseRequested: loaders.sessionMenuLoader.close()
                }

                C.MusicWidget {
                    id: musicWidgetID
                    Layout.preferredWidth: 230
                    onOpenRequested: loaders.musicLoader.open()
                    onCloseRequested: loaders.musicLoader.close()
                }

                C.Apps { }
            }

            // MIDDLE GROUP
            C.DesktopSessions {}

            // RIGHT GROUP
            RowLayout {
                spacing: 8
                Layout.alignment: Qt.AlignRight
                
                C.Tray {Layout.preferredWidth: 45}
                
                C.Volume {
                    id: volumeID
                    Layout.preferredWidth: 60
                    onOpenRequested: loaders.volumeLoader.open()
                    onCloseRequested: loaders.volumeLoader.close()
                }
                C.Stats {
                    id: stats
                    onOpenRequested: loaders.statsLoader.open()
                    onCloseRequested: loaders.statsLoader.close()
                }
                C.DateTime {
                    id: dateTimeID
                    onOpenRequested: loaders.dateLoader.open()
                    onCloseRequested: loaders.dateLoader.close()
                }
                C.Network {Layout.preferredWidth: 20}
                C.Notif {}
            }
        }
    }
}
