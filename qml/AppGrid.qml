import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    property string tabName: ""
    property var apps: []

    GridView {
        id: gridView
        anchors.fill: parent
        cellWidth: 100
        cellHeight: 100
        model: apps

        delegate: AppDelegate {
            tabName: root.tabName
            app: modelData
        }
    }

    // Show message only if Favourites tab and empty
    Text {
        anchors.centerIn: parent
        visible: root.tabName === "Favourites" && (!apps || apps.length === 0)
        text: "No favourites yet.\nRight-click any app and select 'Add to Favourites'."
        font.pixelSize: 18
        color: "#888"
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap
    }
}
