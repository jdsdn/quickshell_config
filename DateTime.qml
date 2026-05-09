import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland

Item {
    id: root
    implicitWidth: clockRect.implicitWidth
    implicitHeight: clockRect.implicitHeight

    property bool isOpen: false

    signal openRequested() 
    signal closeRequested()

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: weatherProcess.running = true
    }

    Component.onCompleted: {
        weatherProcess.running = true
    }

    // weather data
    property string city: "Davao"
    property string tempC: "--"
    property string feelsLike: "--"
    property string condition: "--"
    property string humidity: "--"
    property string windKmph: "--"
    property string maxTemp: "--"
    property string minTemp: "--"
    property string weatherIcon: "󰖐"

    property var weatherCodeMap: ({
        113: "󰖙 ",  // sunny
        116: "󰖕 ",  // partly cloudy
        119: "󰖐 ",  // cloudy
        122: "󰖐 ",  // overcast
        143: "󰖑 ",  // mist
        176: "󰖗 ",  // patchy rain
        179: "󰖘 ",  // patchy snow
        182: "󰖗 ",  // sleet
        185: "󰖘 ",  // freezing drizzle
        200: "󰖓 ",  // thunder
        227: "󰖘 ",  // blowing snow
        230: "󰖘 ",  // blizzard
        248: "󰖑 ",  // fog
        260: "󰖑 ",  // freezing fog
        263: "󰖗 ",  // drizzle
        266: "󰖗 ",  // light drizzle
        281: "󰖗 ",  // freezing drizzle
        284: "󰖗 ",  // heavy drizzle
        293: "󰖗 ",  // light rain
        296: "󰖗 ",  // light rain
        299: "󰖗 ",  // moderate rain
        302: "󰖗 ",  // moderate rain
        305: "󰖗 ",  // heavy rain
        308: "󰖗 ",  // heavy rain
        311: "󰖗 ",  // light sleet
        314: "󰖗 ",  // moderate sleet
        317: "󰖗 ",  // light sleet
        320: "󰖘 ",  // light snow
        323: "󰖘 ",  // patchy snow
        326: "󰖘 ",  // light snow
        329: "󰖘 ",  // patchy moderate snow
        332: "󰖘 ",  // moderate snow
        335: "󰖘 ",  // patchy heavy snow
        338: "󰖘 ",  // heavy snow
        350: "󰖗 ",  // ice pellets
        353: "󰖗 ",  // light shower
        356: "󰖗 ",  // moderate shower
        359: "󰖗 ",  // torrential rain
        362: "󰖗 ",  // light sleet shower
        365: "󰖗 ",  // moderate sleet shower
        368: "󰖘 ",  // light snow shower
        371: "󰖘 ",  // moderate snow shower
        374: "󰖗 ",  // light ice pellet shower
        377: "󰖗 ",  // moderate ice pellet shower
        386: "󰖓 ",  // patchy rain with thunder
        389: "󰖓 ",  // moderate rain with thunder
        392: "󰖓 ",  // patchy snow with thunder
        395: "󰖓 ",  // moderate snow with thunder
    })

    Process {
        id: weatherProcess
        command: ["curl", "-s", `https://wttr.in/${root.city}?format=j1`]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text)
                    let current = data.current_condition[0]
                    let weather = data.weather[0]
                    root.tempC = current.temp_C
                    root.feelsLike = current.FeelsLikeC
                    root.condition = current.weatherDesc[0].value
                    root.humidity = current.humidity
                    root.windKmph = current.windspeedKmph
                    root.maxTemp = weather.maxtempC
                    root.minTemp = weather.mintempC
                    let code = parseInt(current.weatherCode)
                    root.weatherIcon = root.weatherCodeMap[code] ?? "󰖐"
                } catch(e) {
                    console.log("weather parse error:", e)
                }
            }
        }
    }

    // calendar state 
    property var now: new Date()
    property int calYear: now.getFullYear()
    property int calMonth: now.getMonth()

    function daysInMonth(y, m) {
        return new Date(y, m + 1, 0).getDate()
    }

    function firstDayOfMonth(y, m) {
        return new Date(y, m, 1).getDay()
    }

    Rectangle {
        id: clockRect
        implicitWidth: clockText.implicitWidth + 20
        implicitHeight: theme.pillHeight
        radius: theme.pillRadius
        color: theme.surface
        anchors.verticalCenter: parent.verticalCenter

        Text {
            id: clockText
            anchors.centerIn: parent
            color: theme.text
            font.pixelSize: theme.fontSize
            font.bold: theme.bold

            Timer {
                interval: 1000
                running: true
                repeat: true
                triggeredOnStart: true
                onTriggered: clockText.text = Qt.formatDateTime(new Date(), "MMM  dd,  hh:mm") + "  \uf073"
            }
        }

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
                    calMonth = now.getMonth()
                }
            }
        }
    }
}