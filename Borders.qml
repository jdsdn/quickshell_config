import QtQuick
import Quickshell
import Quickshell.Wayland

Scope {
    property var modelData

    property int cornerRadius: 20

    PanelWindow {
        screen: modelData
        WlrLayershell.namespace: "shell-border-left"
        anchors.left: true
        anchors.top: true
        anchors.bottom: true
        implicitWidth: theme.thickness
        color: theme.bg

        // Rectangle {
        //     color: theme.surface
        //     anchors.right: parent.right
        //     implicitWidth: 1
        //     y: cornerRadius - 15
        //     implicitHeight: parent.height - (cornerRadius * 2) + 15
        // }
    }

    // Right border
    PanelWindow {
        screen: modelData
        WlrLayershell.namespace: "shell-border-right"
        anchors.right: true
        anchors.top: true
        anchors.bottom: true
        implicitWidth: theme.thickness - 1
        color: theme.bg

        // Rectangle {
        //     color: theme.surface
        //     anchors.left: parent.left
        //     implicitWidth: 1
        //     y: cornerRadius - 15
        //     implicitHeight: parent.height - (cornerRadius * 2) + 15
        // }
    }

    // Bottom border
    PanelWindow {
        screen: modelData
        WlrLayershell.namespace: "shell-border-bottom"
        anchors.bottom: true
        anchors.left: true
        anchors.right: true
        implicitHeight: theme.thickness - 1
        color: theme.bg

        // Rectangle {
        //     color: theme.surface
        //     anchors.top: parent.top
        //     implicitHeight: 1
        //     x: cornerRadius - 8
        //     implicitWidth: parent.width - (cornerRadius * 2) + 15
        // }
    }
    // top border
    PanelWindow {
        screen: modelData
        WlrLayershell.namespace: "shell-border-top-b"
        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: 2
        color: theme.bg

        // Rectangle {
        //     color: theme.surface
        //     anchors.topMargin: 4
        //     anchors.bottom: parent.bottom
        //     implicitHeight: 10
        //     x: cornerRadius - 11
        //     implicitWidth: parent.width - (cornerRadius * 2) + 18
        // }
    }
}