import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io

RowLayout {
    spacing: 6

    Repeater {
        model: ToplevelManager.toplevels
        delegate: Rectangle {
            id: delegateRect
            required property var modelData

            width: 25
            height: 25
            radius: 4
            color: mouseArea.containsPress ? Qt.lighter(theme.bg, 1.4) : mouseArea.containsMouse ? Qt.lighter(theme.bg, 1.2) : theme.bg

            Behavior on color {
                ColorAnimation {
                    duration: 80
                }
            }

            function resolveIcon(appId) {
                const id = appId.toLowerCase();
                const overrides = {
                    "codium": "file:///usr/share/icons/Papirus/48x48/apps/vscodium.svg",
                    "vscodium": "file:///usr/share/icons/Papirus/48x48/apps/vscodium.svg",
                    "dev.zed.zed": "file:///home/kiyoyo/.local/zed.app/share/icons/hicolor/512x512/apps/zed.png",
                };
                return overrides[id] ?? "";
            }

            Process {
                id: iconFinder
                command: ["bash", "-c", `find /usr/share/icons/Papirus -name "${delegateRect.modelData.appId.toLowerCase().replace(/ /g, "-")}.*" -path "*/48x48/apps/*" 2>/dev/null | head -1`]
                stdout: SplitParser {
                    onRead: data => {
                        const path = data.trim();
                        if (path && appIcon.source == "") {
                            appIcon.source = "file://" + path;
                        }
                    }
                }
                Component.onCompleted: {
                    const pre = delegateRect.resolveIcon(delegateRect.modelData.appId);
                    console.log(delegateRect.modelData.appId)
                    if (pre)
                        appIcon.source = pre;
                    else
                        running = true;
                }
            }

            Image {
                id: appIcon
                anchors.centerIn: parent
                width: 20
                height: 20
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: delegateRect.modelData.activate()
            }
        }
    }
}
