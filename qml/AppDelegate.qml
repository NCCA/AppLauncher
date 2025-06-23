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

    // Main content layer
    Item {
        anchors.fill: parent

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
    }

    // Loader for AboutDialog (singleton per delegate)
    Loader {
        id: aboutDialogLoader
        source: "qrc:/qml/AboutDialog.qml"
        active: false
        onLoaded: {
            if (aboutDialogLoader.item) {
                aboutDialogLoader.item.theme = theme
            }
        }
    }

    // Question mark button in the top-right corner, always on top
    Button {
        id: helpButton
        text: "?"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: 2
        anchors.rightMargin: 2
        width: 20
        height: 24
        font.pixelSize: 12
        z: 10
        contentItem: Item {
                anchors.fill: parent
                Text {
                    text: helpButton.text
                    color: theme === Material.Dark ? "#fff" : "#222"
                    font.pixelSize: 10
                    anchors.centerIn: parent
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        background: Rectangle {
            color: theme === Material.Dark ? "#444" : "#eee"
            border.color: theme === Material.Dark ? "#bbb" : "#aaa"
            radius: 10
        }
        Material.foreground: theme === Material.Dark ? "#fff" : "#222"
        ToolTip.visible: hovered
        ToolTip.text: "About this app"
        onClicked: {
            var aboutText = appLauncher.get_about_text(app.name)
            aboutDialogLoader.active = true
            if (aboutDialogLoader.item) {
                aboutDialogLoader.item.theme = theme
                aboutDialogLoader.item.openWithText(aboutText)
            }
        }
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
        MenuItem {
            text: "Create Desktop Shortcut"
            onTriggered: appLauncher.create_desktop_entry(app)
        }
    }
}
