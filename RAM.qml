import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

Item {
    id: root

    implicitWidth: ramText.implicitWidth
    implicitHeight: ramText.implicitHeight

    Text {
        id: ramText
        color: theme.text
        font.bold: theme.bold
        text: stats.ramusage + "%  "
        font.pixelSize: theme.fontSize
    }
}