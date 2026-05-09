import QtQuick
import Quickshell.Io
import QtQuick.Shapes
import QtQuick.Layouts

import qs as C

RowLayout {
    spacing: 10
    width: parent.width
    Layout.fillWidth: true
    Layout.leftMargin: 15

    property string storageUsed: "0"
    property string storageTotal: "0"

    // used space
    Process {
        id: storageProcess
        command: ["bash", "-c", "df -h / | awk 'NR==2 {print $3\"/\"$2}'"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split('/')
                if (parts.length === 2) {
                    storageUsed = parts[0]
                    storageTotal = parts[1]
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            storageProcess.running = true
        }
    }

    // cpu
    Item {
        Layout.fillWidth: true
        Layout.topMargin: 20
        Layout.alignment: Qt.AlignHCenter

        C.DualCircularProgress {
            implicitSize: 120
            Layout.preferredWidth: 120
            Layout.preferredHeight: 120
            value1: stats.cputemp / 100
            value2: stats.cputil / 100
            lineWidth: 7
            colPrimary: theme.accent
            colSecondary: theme.accent
            fill: false
        
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2
                
                Text {
                    text: stats.cputemp + "°C"
                    color: theme.text
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: "CPU temp"
                    color: theme.textMuted
                    font.pixelSize: 10
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            ColumnLayout {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    margins: 8
                    rightMargin: -3
                    bottomMargin: 28
                }
                
                spacing: 0
                
                Text {
                    text: stats.cputil+ "%"
                    color: theme.text
                    font.pixelSize: 8
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: "Usage"
                    color: theme.textMuted
                    font.pixelSize: 8
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    // gpu
    Item {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter

        C.DualCircularProgress {
            implicitSize: 140
            Layout.preferredWidth: 135
            Layout.preferredHeight: 135
            value1: stats.gputemp / 100
            value2: Math.round(stats.vramPercent) / 100
            lineWidth: 7
            colPrimary: theme.accent
            colSecondary: theme.accent
            fill: false
        
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2
                
                Text {
                    text: stats.gputemp + "°C"
                    color: theme.text
                    font.pixelSize: 24
                    font.bold: false
                }
                Text {
                    text: "GPU temp"
                    color: theme.textMuted
                    font.pixelSize: 10
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            ColumnLayout {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    margins: 8
                    rightMargin: -3
                    bottomMargin: 32
                }
                spacing: 0
                
                Text {
                    text: Math.round(stats.vramPercent) + "%"
                    color: theme.text
                    font.pixelSize: 9
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: "Usage"
                    color: theme.textMuted
                    font.pixelSize: 9
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    Item {
        implicitWidth: 3
    }

    // ram
    Item {
        Layout.topMargin: 17
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignRight

        C.DualCircularProgress {
            implicitSize: 120
            Layout.preferredWidth: 120
            Layout.preferredHeight: 120
            value1: stats.ramusage / 100
            value2: storageUsed.split('G')[0] / storageTotal.split('G')[0]
            lineWidth: 7
            colPrimary: theme.accent
            colSecondary: theme.accent
            fill: false
        
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 2
                
                Text {
                    text: (parseInt(stats.ramUsed) / 1024).toFixed(1) + "GiB"
                    color: theme.text
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: "Memory"
                    color: theme.textMuted
                    font.pixelSize: 10
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            ColumnLayout {
                anchors {
                    right: parent.right
                    bottom: parent.bottom
                    margins: 8
                    rightMargin: -6
                    bottomMargin: 28
                }

                spacing: 0
                
                Text {
                    text: storageUsed
                    color: theme.text
                    font.pixelSize: 8
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: "Storage"
                    color: theme.textMuted
                    font.pixelSize: 8
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}