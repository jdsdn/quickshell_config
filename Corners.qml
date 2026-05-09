import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    property var modelData
    property int cornerRadius: 18

    // tl
    PanelWindow {
        screen: modelData
        WlrLayershell.namespace: "shell-corner-bl"
        anchors.top: true
        anchors.left: true
        implicitWidth: cornerRadius
        implicitHeight: cornerRadius
        color: "transparent"
        margins {
            top: -1
            left: -1
        }
        Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d");
                const s = width;
                ctx.clearRect(0, 0, s, s);
                ctx.fillStyle = theme.bg;
                ctx.beginPath();
                ctx.moveTo(0, s);
                ctx.lineTo(0, 0);
                ctx.lineTo(s, 0);
                ctx.arc(s, s, s, 0, Math.PI / 2, true);
                ctx.closePath();
                ctx.fill();
            }
        }
    }

    // tr
    PanelWindow {
        screen: modelData
        WlrLayershell.namespace: "shell-corner-tr"
        anchors.top: true
        anchors.right: true
        implicitWidth: cornerRadius
        implicitHeight: cornerRadius
        color: "transparent"
        margins {
            top: 0
            right: 0
        }
        Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d");
                const s = width;
                ctx.clearRect(0, 0, s, s);
                ctx.fillStyle = theme.bg;
                ctx.beginPath();
                ctx.moveTo(0, 0);
                ctx.lineTo(s, 0);
                ctx.lineTo(s, s);
                ctx.arc(0, s, s, 0, Math.PI / 2, true);
                ctx.lineTo(0, 0);
                ctx.closePath();
                ctx.fill();
            }
        }
    }

    // bl
    PanelWindow {
        screen: modelData
        WlrLayershell.namespace: "shell-corner-bl-bg"
        anchors.bottom: true
        anchors.left: true
        implicitWidth: cornerRadius
        implicitHeight: cornerRadius
        color: "transparent"
        margins {
            bottom: 0
            left: 0
        }
        Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d");
                const s = width;
                ctx.clearRect(0, 0, s, s);
                ctx.fillStyle = theme.bg;
                ctx.beginPath();
                ctx.moveTo(s, 0);
                ctx.lineTo(0, 0);
                ctx.lineTo(0, s);
                ctx.lineTo(s, s);
                ctx.arc(s, 0, s, Math.PI / 2, Math.PI, false);
                ctx.closePath();
                ctx.fill();
            }
        }
    }

    // br
    PanelWindow {
        screen: modelData
        WlrLayershell.namespace: "shell-corner-br-bg"
        anchors.bottom: true
        anchors.right: true
        implicitWidth: cornerRadius
        implicitHeight: cornerRadius
        color: "transparent"
        margins {
            bottom: 0
            right: 0
        }
        Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d");
                const s = width;
                ctx.clearRect(0, 0, s, s);
                ctx.fillStyle = theme.bg;
                ctx.beginPath();
                ctx.moveTo(0, s);
                ctx.lineTo(s, s);
                ctx.lineTo(s, 0);
                ctx.arc(0, 0, s, 0, Math.PI / 2, false);
                ctx.closePath();
                ctx.fill();
            }
        }
    }
}
