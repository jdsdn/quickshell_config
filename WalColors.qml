import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    readonly property var colors: JSON.parse(walColors.text())

    property color color0: colors.colors.color0
    property color color1: colors.colors.color1
    property color color2: colors.colors.color2
    property color color3: colors.colors.color3
    property color color4: colors.colors.color4
    property color color5: colors.colors.color5
    property color color6: colors.colors.color6
    property color color7: colors.colors.color7
    property color color8: colors.colors.color8
    property color color9: colors.colors.color9
    property color color10: colors.colors.color10
    property color color11: colors.colors.color11
    property color color12: colors.colors.color12
    property color color13: colors.colors.color13
    property color color14: colors.colors.color14
    property color color15: colors.colors.color15

    FileView {
        id: walColors
        path: "/home/kiyoyo/.cache/wal/colors.json"
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }
}
