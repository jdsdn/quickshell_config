import QtQuick

Item {
    id: root
    property bool isOpen: false

    signal openRequested()
    signal closeRequested()
    
    Text {
        id: buttonText
        text: ""
        color: theme.text
        font.pixelSize: theme.fontSizeLg
        anchors.verticalCenter: parent.verticalCenter
        
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: {
                if (root.isOpen) {
                    root.isOpen = false
                    root.closeRequested()
                } else {
                    root.isOpen = true
                    root.openRequested()
                }
            }
        }
    }
}
