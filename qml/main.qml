import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

/**
 * main.qml
 *
 * Main entry point for the AppsHere! application launcher.
 * Provides search functionality, tabbed navigation, and displays app grids.
 * Includes a debug output overlay and a status bar at the bottom.
 */

ApplicationWindow {
    id: rootWindow
    Material.theme: Material.System
    visible: true
    width: 800
    height: 600
    title: "Apps'Ere! 'cause typing is hard."

    property bool debugVisible: false

    menuBar: MainMenu {
        rootWindow: rootWindow
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Main content area
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Debug output overlay (floating)
            DebugOutput {
                id: debugOutput
                objectName: "debugOutput"
                visible: rootWindow.debugVisible
                anchors.centerIn: parent
                z: 100
            }

            // Main app UI
            ColumnLayout {
                anchors.fill: parent

                // Search bar at the top
                SearchBar {
                    id: searchBar
                    onSearch: function (query) {
                        searchResultsModel.clear();
                        if (query.trim().length > 0) {
                            print(query);
                            var results = appLauncher.search_apps(query);
                            for (var i = 0; i < results.length; ++i) {
                                searchResultsModel.append(results[i]);
                            }
                        }
                    }
                    onClear: {
                        searchResultsModel.clear();
                    }
                }

                // Displays search results below the search bar
                SearchResultsView {
                    id: searchResultsView
                    model: searchResultsModel
                }

                // Tab bar for navigation (e.g., Favourites, All Apps)
                TabBar {
                    id: tabBar
                    Layout.fillWidth: true
                    Repeater {
                        model: tabsModel
                        TabButton {
                            text: modelData.tabName
                        }
                    }
                }

                // StackLayout to show the grid for the selected tab
                StackLayout {
                    id: stackLayout
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: tabBar.currentIndex

                    // Dynamically load the correct grid for each tab
                    Repeater {
                        model: tabsModel
                        Loader {
                            id: tabLoader
                            active: true
                            property var tabData: modelData
                            sourceComponent: tabData.tabName === "Favourites" ? favouritesGridComponent : appGridComponent
                        }
                    }

                    // Component for the Favourites grid
                    Component {
                        id: favouritesGridComponent
                        FavouritesGrid {
                            model: tabData.apps
                            //rootWindow: rootWindow
                        }
                    }

                    // Component for the general app grid
                    Component {
                        id: appGridComponent
                        AppGrid {
                            tabName: tabData.tabName
                            model: tabData.apps
                            //rootWindow: rootWindow
                        }
                    }
                }
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4   // This sets the gap between each DiskQuotaBar

            Repeater {
                model: diskQuotas
                DiskQuotaBar {
                    location: modelData.location
                    used: modelData.used
                    quota: modelData.quota
                    limit: modelData.limit
                    Layout.fillWidth: true
                }
            }
        }

        // Status bar at the bottom
        Rectangle {
            id: statusBar
            objectName: "statusBar"
            color: rootWindow.palette ? rootWindow.palette.window : "#222"
            height: 28
            Layout.fillWidth: true
            z: 1000

            Label {
                id: statusLabel
                objectName: "statusLabel"
                text: "Status :"
                color: rootWindow.palette ? rootWindow.palette.text : "#fff"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 12
                font.pixelSize: 14
            }
        }
    }

    // Model to hold search results (must be outside layouts)
    ListModel {
        id: searchResultsModel
    }
}
