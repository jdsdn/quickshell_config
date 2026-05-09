//@ pragma UseQApplication

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs as C

Scope {
    C.Theme { id: theme }
    C.WalColors { id: colors }
    C.MatugenColors { id: matugenColors }

    Variants {
        model: Quickshell.screens
        delegate: C.TopBar {
            property var modelData
            screen: modelData
        }
    }

    Variants {
        model: Quickshell.screens
        C.Borders { }
    }

    Variants {
        model: Quickshell.screens
        C.Corners { }
    }
}
