import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    id: root
    property string location: "/"
    property real used: 0
    property real quota: 1
    property real limit: 1

    spacing: 12
    Layout.fillWidth: true
    height: 32

    Label {
        text: root.location
        font.pixelSize: 14
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 120
        elide: Label.ElideRight
    }

    Rectangle {
        id: barBg
        color: "#e0e0e0"
        radius: 6
        height: 18
        Layout.fillWidth: true
        border.color: "#888"

        Rectangle {
            id: usedBar
            color: used / limit > 0.9 ? "#e53935" : (used / limit > 0.7 ? "#fbc02d" : "#43a047")
            radius: 6
            height: parent.height
            width: Math.max(4, parent.width * Math.min(used / limit, 1.0))
            anchors.left: parent.left
        }

        Rectangle {
            id: quotaMarker
            width: 2
            height: parent.height
            color: "#1976d2"
            x: parent.width * Math.min(quota / limit, 1.0) - width / 2
            anchors.verticalCenter: parent.verticalCenter
            visible: quota < limit
        }
    }

    Label {
        text: (used / 1073741824).toFixed(2) + " GB / " + (limit / 1073741824).toFixed(2) + " GB"
        font.pixelSize: 13
        color: "#444"
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 130
        horizontalAlignment: Text.AlignRight
    }
}
