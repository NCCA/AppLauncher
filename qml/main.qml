import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

/**
 * main.qml
 *
 * Main entry point for the AppsHere! application launcher.
 * Provides search functionality, tabbed navigation, and displays app grids.
 */

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "AppsHere!"

    // Model to hold search results
    ListModel {
        id: searchResultsModel
    }

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
                }
            }

            // Component for the general app grid
            Component {
                id: appGridComponent
                AppGrid {
                    tabName: tabData.tabName
                    model: tabData.apps
                }
            }
        }
    }
}
