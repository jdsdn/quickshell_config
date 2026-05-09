import QtQuick
import Quickshell
import Quickshell.Io

Item {
    implicitWidth: cpuText.implicitWidth
    implicitHeight: cpuText.implicitHeight

    Text {
        id: cpuText
        text: "   " + stats.cputemp + "°C  "
        color: theme.text
        font.pixelSize: theme.fontSize
        font.bold: theme.bold
    }
}