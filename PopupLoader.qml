import QtQuick

Item {
    id: root
    
    property Component popupComponent
    
    function open() {
        if (!loader.active) {
            loader.active = true
        }
        if (loader.item) loader.item.open()
    }
    
    function close() {
        if (loader.item) loader.item.close()
        unloadTimer.start()
    }
    
    Loader {
        id: loader
        active: false
        sourceComponent: root.popupComponent
    }
    
    Timer {
        id: unloadTimer
        interval: 300
        onTriggered: {
            if (loader.item && !loader.item.menuOpen) {
                loader.active = false
            }
        }
    }
}
