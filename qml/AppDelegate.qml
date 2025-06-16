import QtQuick 2.15
import QtQuick.Controls 2.15

/**
 * AppDelegate.qml
 *
 * Represents a single application icon with its name, supporting launching and context menu actions.
 * Used within an app launcher grid or list.
 */

Rectangle {
    // The name of the current tab (e.g., "Favourites", "All Apps")
    property string tabName: ""
    // The app object, expected to have: name, icon, path, execName
    property var app: {}

    width: 90
    height: 90
    color: "#f0f0f0"
    border.color: "#888"
    radius: 8

    // App icon
    Image {
        source: app.icon
        anchors.centerIn: parent
        width: 48
        height: 48
    }

    // App name label
    Text {
        text: app.name
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        font.pixelSize: 14
        elide: Text.ElideRight
    }

    // Mouse interaction area for launching and context menu
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        // Launch app on left click
        onClicked: function (mouse) {
            if (mouse.button === Qt.LeftButton) {
                appLauncher.launch_app(app.path, app.execName);
            }
        }
        // Show context menu on right click
        onPressed: function (mouse) {
            if (mouse.button === Qt.RightButton) {
                contextMenu.popup();
            }
        }
    }

    // Context menu for adding/removing favourites
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
