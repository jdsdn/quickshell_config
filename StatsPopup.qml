import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

import qs as C

PanelWindow {
    id: "statspopup"
    WlrLayershell.exclusiveZone: 0
    WlrLayershell.namespace: "stats-menu-overlay"

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    margins.top: 0

    color: "transparent"
    visible: menuOpen || closing

    property bool menuOpen: false
    property bool closing: false

    ListModel {
        id: topProcessesModel
    }

    // top processes
    Process {
        id: topProcesses
        command: ["bash", "-c", "ps -eo comm,rss --sort=-rss | tail -n +2 | awk '{mem[$1]+=$2} END {for (name in mem) print name, mem[name]}' | sort -k2 -rn | head -n 13"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(/\s+/)

                if (parts.length >= 2) {
                    let rss = parseInt(parts[1])
                    if (isNaN(rss) || rss === 0) return

                    topProcessesModel.append({
                        name: parts[0],
                        memoryMB: (rss / 1024).toFixed(1)
                    })
                }
            }
        }
        onRunningChanged: {
            if (running) topProcessesModel.clear()
        }
    }

    function open() {
        closing = false
        menuOpen = true
        topProcesses.running = true
    }

    function close() {
        if (closing) return
        closing = true
        menuOpen = false
        closeTimer.start()
        stats.isOpen = false
    }

    Timer {
        id: closeTimer
        interval: 250
        onTriggered: {
            closing = false
            menuOpen = false
        }
    }

    // Timer {
    //     interval: 2000
    //     running: true
    //     repeat: true
    //     triggeredOnStart: true
    //     onTriggered: {
    //         topProcesses.running = true
    //     }
    // }

    MouseArea {
        anchors.fill: parent
        onClicked: close()

        Rectangle {
            id: menuRect
            width: 450
            height: 520
            color: theme.bg
            anchors.top: parent.top
            anchors.right: parent.right
            opacity: menuOpen ? 1 : 0
            bottomLeftRadius: 10
            bottomRightRadius: 10
            anchors.topMargin: 0
            anchors.rightMargin: 75

            transform: Translate {
                y: menuOpen ? 0 : -menuRect.height
                Behavior on y {
                    NumberAnimation {
                        duration: theme.duration
                        easing.type: Easing.OutCubic
                    }
                }
            }

            Behavior on opacity {
                NumberAnimation { duration: theme.duration }
            }

            ColumnLayout {
                spacing: 1
                width: parent.width
                Layout.fillWidth: true

                C.StatsPopupCircles {}

                // Separator
                Rectangle {
                    height: 1
                    color: theme.border
                    Layout.fillWidth: true
                    opacity: 0.5
                    Layout.margins: 10
                    Layout.topMargin: 145
                }

                // Top 10 Processes
                ColumnLayout {
                    spacing: 6
                    Layout.margins: 12
                    Layout.topMargin: 5
                    Layout.fillWidth: true

                    Text {
                        text: "Top Memory Processes"
                        color: theme.text
                        font.pixelSize: theme.fontSize
                    }

                    Repeater {
                        model: topProcessesModel
                        delegate: RowLayout {
                            Layout.fillWidth: true
                            spacing: 8
                            
                            Text {
                                text: model.name
                                color: theme.text
                                font.pixelSize: theme.fontSizeSm
                                Layout.fillWidth: true
                            }
                            
                            Text {
                                text: (parseFloat(model.memoryMB) / 1024).toFixed(1) + "Gb"
                                color: theme.textMuted
                                font.pixelSize: theme.fontSizeSm
                                Layout.preferredWidth: 80
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }
                }
            }

            Canvas {
                width: 15
                height: 15
                anchors.topMargin: 0
                anchors.rightMargin: -15
                anchors.top: parent.top
                anchors.right: parent.right
                onPaint: {
                    const ctx = getContext("2d")
                    const s = 15
                    ctx.clearRect(0, 0, s, s)
                    ctx.fillStyle = theme.bg
                    ctx.beginPath()
                    ctx.moveTo(0,s)
                    ctx.lineTo(0,0)
                    ctx.lineTo(s,0)
                    ctx.arc(s, s, s, 0, Math.PI/2, true)
                    ctx.closePath()
                    ctx.fill()
                }
            }

            Canvas {
                width: 15
                height: 15
                anchors.topMargin: 0
                anchors.leftMargin: -15
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.fill: parent
                onPaint: {
                    const ctx = getContext("2d")
                    const s = 15
                    ctx.clearRect(0, 0, s, s)
                    ctx.fillStyle = theme.bg
                    ctx.beginPath()
                    ctx.moveTo(0,0)
                    ctx.lineTo(s,0)
                    ctx.lineTo(s,s)
                    ctx.arc(0, s, s, 0, Math.PI/2, true)
                    ctx.lineTo(0,0)
                    ctx.closePath()
                    ctx.fill()
                }
            }
        }
    }
}
