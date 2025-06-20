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
        title: "Theme"
        MenuItem {
            text: "System"
            onTriggered: appLauncher.set_theme("System")
        }
        MenuItem {
            text: "Light"
            onTriggered: appLauncher.set_theme("Light")
        }
        MenuItem {
            text: "Dark"
            onTriggered: appLauncher.set_theme("Dark")
        }
    }

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
            onTriggered: {
                onTriggered: aboutDialog.open();
            }
        }
        MenuItem {
            text: "Documentation"
            onTriggered: {
                Qt.openUrlExternally("qrc:/help/help.html");
            }
        }
    }

    Dialog {
        id: aboutDialog
        title: "Apps'ere! Launcher"
        modal: true
        standardButtons: Dialog.Ok
        // Center the dialog on the rootWindow
        x: rootWindow ? (rootWindow.width - width) / 2 : 0
        y: rootWindow ? (rootWindow.height - height) / 2 : 0

        contentItem: ColumnLayout {
            width: 300
            spacing: 12
            Label {
                text: "Simple App launcher for Linux"
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
                text: "Written by Jon Macey jmacey@bournemouth.ac.uk"
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: '<a href="https://github.com/NCCA/AppLauncher">https://github.com/NCCA/AppLauncher</a>'
                textFormat: Text.RichText
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
    }
}
