import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "AppsHere!"

    ListModel {
        id: searchResultsModel
    }

    ColumnLayout {
        anchors.fill: parent

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

        SearchResultsView {
            id: searchResultsView
            model: searchResultsModel
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
