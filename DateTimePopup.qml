import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Wayland


PanelWindow {
    id: root
    WlrLayershell.exclusiveZone: 0
    visible: root.menuOpen || root.closing
    WlrLayershell.namespace: "date-overlay"

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    margins.top: 0
    margins.right: -1
    color: "transparent"

    property bool menuOpen: false
    property bool closing: false

    function open() {
        closing = false
        menuOpen = true
        dateTimeID.calMonth = dateTimeID.now.getMonth()
    }

    function close() {
        if (closing) return
        closing = true
        menuOpen = false
        closeTimer.start()
        dateTimeID.isOpen = false
    }

    Timer {
        id: closeTimer
        interval: 250
        onTriggered: {
            root.closing = false
            menuOpen = false
        }
    }

    function daysInMonth(y, m) {
        return new Date(y, m + 1, 0).getDate()
    }

    function firstDayOfMonth(y, m) {
        return new Date(y, m, 1).getDay()
    }

    MouseArea {
        anchors.fill: parent
        onClicked: close()

        Rectangle {
            id: popupRect
            width: 320
            height: 400
            color: theme.bg
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: -3
            anchors.rightMargin: -3
            bottomLeftRadius: 10

            opacity: root.menuOpen ? 1 : 0

            transform: Translate {
                y: root.menuOpen ? 0 : -popupRect.height
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

            MouseArea {
                anchors.fill: parent
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.leftMargin: 15
                anchors.rightMargin: 15
                anchors.topMargin: 0
                spacing: 0

                // WEATHER CARD
                ColumnLayout {
                    id: weatherCol
                    Layout.fillWidth: true
                    Layout.bottomMargin: -20
                    spacing: 8

                    // top row: icon + temp + condition
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text {
                            text: dateTimeID.weatherIcon
                            font.pixelSize: 48
                            color: theme.text
                        }

                        ColumnLayout {
                            spacing: 2

                            Text {
                                text: dateTimeID.tempC + " °C"
                                font.pixelSize: 32
                                font.bold: true
                                color: theme.text
                            }

                            Text {
                                text: dateTimeID.condition
                                font.pixelSize: 13
                                color: theme.textMuted
                            }
                        }

                        Item { Layout.fillWidth: true }

                        // high/low
                        ColumnLayout {
                            spacing: 2
                            Layout.alignment: Qt.AlignRight

                            Text {
                                text: "↑ " + dateTimeID.maxTemp + "°"
                                font.pixelSize: 13
                                color: theme.text
                                Layout.alignment: Qt.AlignRight
                            }
                            Text {
                                text: "↓ " + dateTimeID.minTemp + "°"
                                font.pixelSize: 13
                                color: theme.textMuted
                                Layout.alignment: Qt.AlignRight
                            }
                        }
                    }

                    // bottom row: feels like, humidity, wind
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        Text {
                            text: "Feels " + dateTimeID.feelsLike + "°C"
                            font.pixelSize: 12
                            color: theme.textMuted
                        }

                        Text {
                            text: "   " + dateTimeID.humidity + "%"
                            font.pixelSize: 12
                            color: theme.textMuted
                        }

                        Text {
                            text: "   " + dateTimeID.windKmph + " km/h"
                            font.pixelSize: 12
                            color: theme.textMuted
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "  " + dateTimeID.city
                            font.pixelSize: 12
                            color: theme.textMuted
                        }
                    }
                }

                // divider
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: theme.border
                    opacity: 0.5
                    Layout.bottomMargin: -50
                }

                // CALENDAR
                ColumnLayout {
                    id: calendarCol
                    Layout.fillWidth: true
                    spacing: 0

                    // month nav
                    RowLayout {
                        Layout.fillWidth: true
                        Layout.bottomMargin: 20

                        Text {
                            text: "〈"
                            color: theme.textMuted
                            font.pixelSize: 14
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (dateTimeID.calMonth === 0) {
                                        dateTimeID.calMonth = 11
                                        dateTimeID.calYear--
                                    } else {
                                        dateTimeID.calMonth--
                                    }
                                }
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: Qt.formatDate(new Date(dateTimeID.calYear, dateTimeID.calMonth, 1), "MMMM yyyy")
                            font.pixelSize: 14
                            font.bold: true
                            color: theme.text
                        }

                        Item { Layout.fillWidth: true }

                        Text {
                            text: "〉"
                            color: theme.textMuted
                            font.pixelSize: 14
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (dateTimeID.calMonth === 11) {
                                        dateTimeID.calMonth = 0
                                        dateTimeID.calYear++
                                    } else {
                                        dateTimeID.calMonth++
                                    }
                                }
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        height: 28 * 6 + 4 * 6

                        // day headers
                        Grid {
                            columns: 7
                            Layout.fillWidth: true
                            spacing: 0

                            Repeater {
                                model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
                                Text {
                                    text: modelData
                                    width: (popupRect.width - 32) / 7
                                    horizontalAlignment: Text.AlignHCenter
                                    font.pixelSize: 11
                                    color: theme.textMuted
                                }
                            }

                            // empty cells for first day offset
                            Repeater {
                                model: firstDayOfMonth(dateTimeID.calYear, dateTimeID.calMonth)
                                Item {
                                    width: (popupRect.width - 32) / 7
                                    height: 28
                                }
                            }

                            // day cells
                            Repeater {
                                model: daysInMonth(dateTimeID.calYear, dateTimeID.calMonth)
                                Rectangle {
                                    property bool isToday: {
                                        let t = new Date()
                                        return index + 1 === t.getDate() &&
                                            dateTimeID.calMonth === t.getMonth() &&
                                            dateTimeID.calYear === t.getFullYear()
                                    }
                                    width: (popupRect.width - 32) / 7
                                    height: 35
                                    radius: 100
                                    color: isToday ? theme.text : "transparent"

                                    Text {
                                        anchors.centerIn: parent
                                        text: index + 1
                                        font.pixelSize: 12
                                        color: isToday ? theme.bg : theme.text
                                        font.bold: isToday
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // TL corner
            Canvas {
                width: 15
                height: 15
                anchors.topMargin: 3
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

            // BR corner
            Canvas {
                width: 15
                height: 15
                anchors.bottomMargin: -15
                anchors.rightMargin: 4
                anchors.bottom: parent.bottom
                anchors.right: parent.right
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