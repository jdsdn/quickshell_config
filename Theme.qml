import QtQuick
import Quickshell

Scope {
    id: root

    // switch between pywal and matugen here
    readonly property bool useMatugen: false

    // colors
    readonly property color bg: useMatugen ? matugenColors.background : colors.color0
    readonly property color surface: useMatugen ? matugenColors.surface : Qt.lighter(colors.color0, 1.5)
    readonly property color text: useMatugen ? matugenColors.text : colors.color7
    readonly property color textMuted: useMatugen ? matugenColors.textMuted : colors.color8
    readonly property color accent: useMatugen ? matugenColors.primary : colors.color1
    readonly property color border: useMatugen ? matugenColors.outline : colors.color8

    // typography
    readonly property int fontSize: 14
    readonly property int fontSizeSm: 12
    readonly property int fontSizeXs: 10
    readonly property int fontSizeLg: 16
    readonly property bool bold: false

    // pill
    readonly property real pillRadius: 100
    readonly property real pillHeight: 30
    readonly property real pillLighter: 3

    // rect
    readonly property real thickness: 9
    readonly property real rectHeight: 40

    // popup
    readonly property real duration: 350
}
