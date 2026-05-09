import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

import qs as C

Rectangle {
    id: stats

    implicitWidth: 208
    color: theme.surface
    radius: theme.pillRadius
    implicitHeight: theme.pillHeight

    property bool isOpen: false

    property string cputil: "0°C  "
    property string cputemp: "0°C  "

    property string ramTotal: "0"
    property string gputemp: "0°C  "

    property string ramUsed: "0"
    property string ramusage: "0"

    property string vramUsedMB: "0"
    property string vramPercent: "0"
    property string vramTotalMB: "16384"

    signal openRequested()
    signal closeRequested()

    // cpu
    Process {
        id: cpuProcess
        command: ["bash", "-c", "sensors -j | jq -r '.[\"k10temp-pci-00c3\"].Tctl.temp1_input | floor'"]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim()) {
                    cputemp = (data.trim())
                }
            }
        }
    }

    // cpu util
    Process {
        id: cpuUtilProcess
        command: ["bash", "-c", "top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}' | cut -d'.' -f1"]
        stdout: SplitParser {
            onRead: data => {
                let util = parseInt(data.trim())
                if (!isNaN(util)) {
                    cputil = util
                }
            }
        }
    }

    // gpu
    Process {
        id: gpuProcess
        command: ["bash", "-c", "sensors -j | jq -r '.[\"amdgpu-pci-2800\"].mem.temp3_input | floor'"]
        stdout: SplitParser {
            onRead: data => {
                if (data.trim()) gputemp = data.trim()
            }
        }
    }

    // ram
    Process {
        id: ramProcess
        command: ["bash", "-c", "free | awk '/Mem:/ {printf \"%.0f|%.0f|%.0f\", $3/$2 * 100, $3/1024, $2/1024}'"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split('|')
                if (parts.length === 3) {
                    ramusage = parts[0]
                    ramUsed = parts[1]  // In MB
                    ramTotal = parts[2] // In MB
                }
            }
        }
    }

    // vram
    Process {
        id: vramProcess
        command: ["bash", "-c", "radeontop -d - -l 1 | awk -F'[, ]+' '{for(i=1;i<=NF;i++) if($i==\"vram\") print $(i+1), $(i+2)}'"]
        stdout: SplitParser {
            onRead: data => {
                let parts = data.trim().split(' ')
                if (parts.length === 2) {
                    let percent = parts[0].replace('%', '')
                    let used = parts[1].replace('mb', '')
                    vramPercent = parseFloat(percent).toFixed(1)
                    vramUsedMB = parseFloat(used).toFixed(0)
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
            gpuProcess.running = true
            cpuProcess.running = true
            ramProcess.running = true
            vramProcess.running = true
            cpuUtilProcess.running = true
        }
    }

    RowLayout {
        spacing: 15
        Layout.alignment: Qt.AlignRight
        anchors.verticalCenter: parent.verticalCenter

        C.CPU {}
        C.GPU {}
        C.RAM {}
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
            if (isOpen) {
                stats.isOpen = false
                closeRequested()
            } else {
                stats.isOpen = true
                openRequested()
            }
        }
    }
}
