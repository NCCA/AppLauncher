import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ScrollView {
    id: scrollArea
    property alias model: searchResultsView.model
    Layout.fillWidth: true
    Layout.preferredHeight: Math.min(model.count * 64, 320) // 5 items max visible, adjust as needed
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

                Image {
                    source: model.icon
                    height: delegateRect.height
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    onStatusChanged: {
                        if (status === Image.Error) {
                            source = "qrc:/qml/placeholder.png";
                        }
                    }
                }
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
                Button {
                    text: "Launch"
                    onClicked: appLauncher.launch_app(model.path, model.execName)
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                }
                Button {
                    text: "Add to Favourites"
                    onClicked: appLauncher.addToFavourites(model.name)
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                }
            }
        }
    }
}
