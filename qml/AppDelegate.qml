import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Rectangle {
    property string tabName: ""
    property var app: {}
    property var rootWindow
    property int theme: Material.theme
    width: 90
    height: 90
    color: theme === Material.Dark ? "#333" : "#fff"
    border.color: theme === Material.Dark ? "#bbb" : "#888"

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
        color: theme === Material.Dark ? "#fff" : "#222"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        hoverEnabled: true

        onClicked: function (mouse) {
            if (mouse.button === Qt.LeftButton) {
                appLauncher.launch_app(app.path, app.execName, app.flags, !!app.popup);
            }
        }
        onPressed: function (mouse) {
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup();
            }
        }

        ToolTip.visible: containsMouse && !!app.desc
        ToolTip.text: app.desc || ""
        ToolTip.delay: 300
    }

    Menu {
        id: contextMenu
        MenuItem {
            text: "Add to Favourites"
            visible: tabName !== "Favourites"
            onTriggered: appLauncher.add_to_favourites(app.name)
        }
        MenuItem {
            text: "Remove from Favourites"
            visible: tabName === "Favourites"
            onTriggered: appLauncher.remove_from_favourites(app.name)
        }
    }
}
