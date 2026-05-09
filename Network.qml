import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root
    implicitWidth: networkText.implicitWidth
    implicitHeight: networkText.implicitHeight

    property string essid: ""
    property int strength: 0
    property string state: "ethernet" // wifi, ethernet, linked, disconnected

    Process {
        id: networkProcess
        command: ["bash", "-c", "nmcli -t -f TYPE,STATE,CONNECTION device | grep activated | head -1"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(":")
                let type = parts[0]
                if (type === "wifi") root.state = "wifi"
                else if (type === "ethernet") root.state = "ethernet"
                else root.state = "disconnected"
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: wifiProcess
        command: ["bash", "-c", "nmcli -t -f SSID,SIGNAL dev wifi | grep -v '^:' | head -1"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(":")
                root.essid = parts[0] ?? ""
                root.strength = parseInt(parts[1]) ?? 0
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            networkProcess.running = true
            wifiProcess.running = true
        }
    }

    property string networkIcon: {
        switch(root.state) {
            case "wifi":
                if (root.strength >= 75) return "󰤨"
                if (root.strength >= 50) return "󰤥"
                if (root.strength >= 25) return "󰤢"
                return "󰤟"
            case "ethernet": return "\uf484"
            case "linked": return "\uf44c"
            default: return "\uea6c"
        }
    }

    Text {
        id: networkText
        text: root.state === "wifi" 
            ? networkIcon + " " + root.essid + " " + root.strength + "%" 
            : networkIcon
        color: theme.text
        font.pixelSize: theme.fontSize
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Quickshell.execDetached(["nm-connection-editor"])
    }
}