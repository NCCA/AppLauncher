import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    property string tabName: ""
    property var app: {}

    width: 90
    height: 90
    color: "#f0f0f0"
    border.color: "#888"
    radius: 8

    Image {
        source: app.icon
        anchors.centerIn: parent
        width: 48
        height: 48
    }
    Text {
        text: app.name
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        font.pixelSize: 14
        elide: Text.ElideRight
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: function (mouse) {
            if (mouse.button === Qt.LeftButton) {
                appLauncher.launch_app(app.path, app.execName);
            }
        }
        onPressed: function (mouse) {
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup();
            }
        }
    }

    Menu {
        id: contextMenu
        MenuItem {
            text: "Add to Favourites"
            visible: tabName !== "Favourites"
            onTriggered: {
                appLauncher.add_to_favourites(app.name);
            }
        }
        MenuItem {
            text: "Remove from Favourites"
            visible: tabName === "Favourites"
            onTriggered: {
                appLauncher.remove_from_favourites(app.name);
            }
        }
    }
}
