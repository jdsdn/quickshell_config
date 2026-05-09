import QtQuick
import Quickshell
import Quickshell.Io

Scope {
    id: root

    FileView {
        id: matugenColors
        path: "/home/kiyoyo/.local/state/quickshell/user/generated/colors.json"
        blockLoading: true
        watchChanges: true
        onFileChanged: reload()
    }

    readonly property var palette: JSON.parse(matugenColors.text())

    // direct shortcuts matching your template
    property color background: palette.colors.background
    property color surface: palette.colors.surface
    property color primary: palette.colors.primary
    property color onPrimary: palette.colors.onPrimary
    property color secondary: palette.colors.secondary
    property color onSecondary: palette.colors.onSecondary
    property color tertiary: palette.colors.tertiary
    property color error: palette.colors.error
    property color outline: palette.colors.outline
    property color text: palette.colors.text
    property color textMuted: palette.colors.textMuted
}
