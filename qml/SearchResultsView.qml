import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ListView {
    id: searchResultsView
    property var searchResults: []
    Layout.fillWidth: true
    Layout.preferredHeight: searchResults.length > 0 ? 120 : 0
    model: searchResults
    visible: searchResults.length > 0
    delegate: Rectangle {
        width: parent.width
        height: 60
        color: "#e0e0e0"
        border.color: "#888"
        radius: 8
        RowLayout {
            anchors.fill: parent
            spacing: 12
            Image {
                source: modelData.icon
                width: 40
                height: 40
                Layout.alignment: Qt.AlignVCenter
            }
            ColumnLayout {
                Layout.alignment: Qt.AlignVCenter
                Text {
                    text: modelData.name
                    font.pixelSize: 16
                    font.bold: true
                }
            }
            Button {
                text: "Launch"
                onClicked: appLauncher.launchApp(modelData.path, modelData.execName)
                Layout.alignment: Qt.AlignVCenter
            }
            Button {
                text: "Add to Favourites"
                onClicked: appLauncher.addToFavourites(modelData.name)
                Layout.alignment: Qt.AlignVCenter
            }
        }
    }
}
