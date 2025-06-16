import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

GridView {
    id: gridView
    property string tabName: ""
    Layout.fillWidth: true
    Layout.fillHeight: true
    cellWidth: 100
    cellHeight: 100
    // model is now set from outside, do not set it here

    delegate: AppDelegate {
        tabName: gridView.tabName
        app: modelData
    }
}
