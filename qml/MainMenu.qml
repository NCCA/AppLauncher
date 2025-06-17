import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

/**
 * MainMenu.qml
 *
 * Provides the main menu bar with a Help → About item and an About dialog.
 * Usage: Set as the menuBar property of ApplicationWindow.
 */

MenuBar {
    id: mainMenuBar
    property var rootWindow
    property alias aboutDialog: aboutDialog

    Menu {
        title: "Debug"
        MenuItem {
            text: "Show Output"
            onTriggered: {
                if (rootWindow) {
                    rootWindow.debugVisible = !rootWindow.debugVisible;
                }
            }
        }
    }
    Menu {
        title: "Help"
        MenuItem {
            text: "About"
            onTriggered: aboutDialog.open()
        }
    }
    Menu {
        title: "Theme"
        MenuItem {
            text: "System"
            onTriggered: rootWindow.Material.theme = Material.System
        }
        MenuItem {
            text: "Light"
            onTriggered: rootWindow.Material.theme = Material.Light
        }
        MenuItem {
            text: "Dark"
            onTriggered: rootWindow.Material.theme = Material.Dark
        }
    }

    Dialog {
        id: aboutDialog
        title: "About AppsHere!"
        modal: true
        standardButtons: Dialog.Ok
        contentItem: ColumnLayout {
            width: 300
            spacing: 12
            Label {
                text: "AppsHere! Application Launcher"
                font.bold: true
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
            Label {
                text: "Version 1.0.0"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
            Label {
                text: "A simple and modern launcher for your desktop apps."
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}
