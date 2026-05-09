import QtQuick

// Loaders for lesser ram
Item {
    // Session Menu
    property alias sessionMenuLoader: sessionMenuLoader
    property Component sessionMenuComponent: sessionMenuComponent

    PopupLoader {
        id: sessionMenuLoader
        popupComponent: sessionMenuComponent
    }
    
    Component {
        id: sessionMenuComponent
        SessionMenu {}
    }

    // Music Widget
    property alias musicLoader: musicLoader
    property Component musicComponent: musicComponent

    PopupLoader {
        id: musicLoader
        popupComponent: musicComponent
    }

    Component {
        id: musicComponent
        MusicPopup {}
    }

    // Stats Widget
    property alias statsLoader: statsLoader
    property Component statsComponent: statsComponent

    PopupLoader {
        id: statsLoader
        popupComponent: statsComponent
    }

    Component {
        id: statsComponent
        StatsPopup {}
    }

    // Date Widget
    property alias dateLoader: dateLoader
    property Component dateComponent: dateComponent

    PopupLoader {
        id: dateLoader
        popupComponent: dateComponent
    }

    Component {
        id: dateComponent
        DateTimePopup {}
    }

    // Volume Widget
    property alias volumeLoader: volumeLoader
    property Component volumeComponent: volumeComponent

    PopupLoader {
        id: volumeLoader
        popupComponent: volumeComponent
    }

    Component {
        id: volumeComponent
        VolumePopup {} 
    }
}