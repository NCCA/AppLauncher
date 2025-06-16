import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

/**
 * SearchResultsView.qml
 *
 * Displays search results in a scrollable list.
 * Each result shows the app icon, name, and buttons to launch or add to favourites.
 * The model is expected to be set externally.
 */

ScrollView {
    id: scrollArea

    // Expose the ListView's model as a property alias
    property alias model: searchResultsView.model

    Layout.fillWidth: true
    // Show up to 5 items (each 64px tall), adjust as needed
    Layout.preferredHeight: Math.min(model.count * 64, 320)
    // Only visible if there are search results
    visible: model.count > 0

    ListView {
        id: searchResultsView
        width: parent.width
        height: contentHeight
        model: model
        interactive: true
        clip: true

        delegate: Rectangle {
            id: delegateRect
            width: ListView.view ? ListView.view.width : 0
            height: 60
            color: "#e0e0e0"
            border.color: "#888"
            radius: 8

            RowLayout {
                anchors.fill: parent
                spacing: 12
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                // App icon
                Image {
                    source: model.icon
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                }

                // App name
                ColumnLayout {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Text {
                        text: model.name
                        font.pixelSize: 16
                        font.bold: true
                        horizontalAlignment: Text.AlignLeft
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    }
                }

                // Launch button
                Button {
                    text: "Launch"
                    onClicked: appLauncher.launch_app(model.path, model.execName)
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                }

                // Add to Favourites button
                Button {
                    text: "Add to Favourites"
                    onClicked: appLauncher.add_to_favourites(model.name)
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                }
            }
        }
    }
}
