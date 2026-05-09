import QtQuick
import QtQuick.Shapes
// import qs.modules.common

/**
 * Material 3 circular progress. See https://m3.material.io/components/progress-indicators/specs
 */
Item {
    id: root

    implicitWidth: implicitSize
    implicitHeight: implicitSize

    property int implicitSize: 30
    property int lineWidth: 2
    property real value1: 0
    property real value2: 0
    property color colPrimary: 'red'
    property color colSecondary: 'blue'
    property real gapAngle: 360 / 27
    property bool fill: false
    property int fillOverflow: 2
    property bool enableAnimation: true
    property int animationDuration: 800
    property var easingType: Easing.OutCubic

    property real degree1: value1 * 360
    property real degree2: value2 * 360
    property real centerX: root.width / 2
    property real centerY: root.height / 2
    property real arcRadius: root.implicitSize / 2 - root.lineWidth
    property real startAngle: -120

    Behavior on degree1 {
        enabled: root.enableAnimation
        NumberAnimation {
            duration: root.animationDuration
            easing.type: root.easingType
        }

    }

    Behavior on degree2 {
        enabled: root.enableAnimation
        NumberAnimation {
            duration: root.animationDuration
            easing.type: root.easingType
        }

    }

    Loader {
        active: root.fill
        anchors.fill: parent
        
        sourceComponent: Rectangle {
            radius: 9999
            color: root.colSecondary
        }
    }

    Shape {
        anchors.fill: parent
        layer.enabled: true
        layer.smooth: true
        preferredRendererType: Shape.CurveRenderer

        // max paths
        ShapePath {
            id: primaryPath
            strokeColor: !theme.useMatugen? theme.textMuted : theme.surface
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.startAngle
                sweepAngle: 0.35 * 360
            }
        }
        ShapePath {
            id: secondaryPath
            strokeColor: !theme.useMatugen? theme.textMuted : theme.surface
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.startAngle - root.gapAngle
                sweepAngle: -(360 - (0.55 * 360) - 1 * root.gapAngle)
            }
        }

        // value paths
        ShapePath {
            id: primaryValuePath
            strokeColor: root.colPrimary
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: root.startAngle
                sweepAngle: root.value1 * (0.35 * 360)
            }
        }
        ShapePath {
            id: secondaryValuePath
            strokeColor: root.colSecondary
            strokeWidth: root.lineWidth
            capStyle: ShapePath.RoundCap
            fillColor: "transparent"
            PathAngleArc {
                centerX: root.centerX
                centerY: root.centerY
                radiusX: root.arcRadius
                radiusY: root.arcRadius
                startAngle: 45
                sweepAngle: root.value2 * (0.50 * 360)
            }
        }
    }
}
