import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "App Launcher"

    property var searchResults: []

    ColumnLayout {
        anchors.fill: parent

        SearchBar {
            id: searchBar
            onSearch: function (query) {
                if (query.trim().length > 0) {
                    searchResults = appLauncher.searchApps(query);
                } else {
                    searchResults = [];
                }
            }
            onClear: {
                searchResults = [];
            }
        }

        SearchResultsView {
            id: searchResultsView
            searchResults: searchResults
        }

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

        StackLayout {
            id: stackLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: tabBar.currentIndex

            Repeater {
                model: tabsModel
                AppGrid {
                    tabName: modelData.tabName
                    apps: modelData.apps
                }
            }
        }
    }
}
