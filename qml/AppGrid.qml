import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

GridView {
    id: gridView
    property string tabName: ""
    property var apps: []
    Layout.fillWidth: true
    Layout.fillHeight: true
    cellWidth: 100
    cellHeight: 100
    model: apps

    delegate: AppDelegate {
        tabName: gridView.tabName
        app: modelData
    }
}
