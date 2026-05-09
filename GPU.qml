import QtQuick
import Quickshell
import Quickshell.Io

Item {
    implicitWidth: gpuText.implicitWidth
    implicitHeight: gpuText.implicitHeight

    Text {
        id: gpuText
        text: stats.gputemp + "°C  "
        color: theme.text
        font.pixelSize: theme.fontSize
        font.bold: theme.bold
    }
}
