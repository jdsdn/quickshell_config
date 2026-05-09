import QtQuick
import Quickshell
import Quickshell.Wayland

Item {
    id: root
    visible: true  // always visible so the button shows
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
    }

    Timer {
        id: closeTimer
        interval: 250
        onTriggered: {
            root.closing = false
            menuOpen = false
        }
    }

    // the button that sits in the bar
    Text {
        id: powerButton
        text: ""
        color: theme.text
        font.pixelSize: theme.fontSizeLg
        anchors.verticalCenter: parent.verticalCenter

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
                if (menuOpen && !closing) close()
                else open()
            }
        }
    }

    // the overlay + popup
    PanelWindow {
        WlrLayershell.namespace: "popup-menu-overlay"
        WlrLayershell.exclusiveZone: 0
        WlrLayershell.layer: WlrLayershell.Layer.Overlay
        WlrLayershell.keyboardFocus: WlrLayershell.KeyboardFocus.OnDemand

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true
        margins.top: 40  // below topbar

        color: "transparent"
        visible: root.menuOpen || root.closing

        MouseArea {
            anchors.fill: parent
            onClicked: root.close()

            Rectangle {
                id: menuRect
                width: 50
                height: 200
                color: theme.bg
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                opacity: root.menuOpen ? 1 : 0

                transform: Translate {
                    x: root.menuOpen ? 0 : -menuRect.width
                    Behavior on x {
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
            }
        }
    }
}
