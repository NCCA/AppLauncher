import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

RowLayout {
    id: root
    property string location: "/"
    property real used: 0
    property real quota: 1
    property real limit: 1
    property int theme: Material.theme

    spacing: 12
    Layout.fillWidth: true
    height: 32

    Label {
        text: root.location
        font.pixelSize: 14
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 120
        elide: Label.ElideRight
        color: theme === Material.Dark ? "#fff" : "#222"
    }

    Rectangle {
        id: barBg
        color: theme === Material.Dark ? "#333" : "#e0e0e0"
        radius: 6
        height: 18
        Layout.fillWidth: true
        border.color: theme === Material.Dark ? "#bbb" : "#888"

        Rectangle {
            id: usedBar
            color: used / limit > 0.9 ? "#e53935"
                  : used / limit > 0.7 ? "#fbc02d"
                  : (theme === Material.Dark ? "#66bb6a" : "#43a047")
            radius: 6
            height: parent.height
            width: Math.max(4, parent.width * Math.min(used / limit, 1.0))
            anchors.left: parent.left
        }

        Rectangle {
            id: quotaMarker
            width: 2
            height: parent.height
            color: theme === Material.Dark ? "#90caf9" : "#1976d2"
            x: parent.width * Math.min(quota / limit, 1.0) - width / 2
            anchors.verticalCenter: parent.verticalCenter
            visible: quota < limit
        }
    }

    Label {
        text: (used).toFixed(2) + " GB / " + (limit).toFixed(2) + " GB"
        font.pixelSize: 13
        color: theme === Material.Dark ? "#fff" : "#222"

        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 130
        horizontalAlignment: Text.AlignRight
    }
}
