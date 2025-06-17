import QtQuick 2.15
import QtQuick.Controls 2.15

/**
 * FavouritesGrid.qml
 *
 * Displays a grid of favourite applications, allowing users to reorder them via drag-and-drop.
 * Uses AppDelegate for each app icon and provides a drag handle for reordering.
 * The model is expected to be set externally (e.g., from main.qml).
 */

GridView {
    id: gridView
    property var rootWindow
    cellWidth: 100
    cellHeight: 100

    model: model

    property int dragIndex: -1

    delegate: Item {
        id: delegateItem
        width: gridView.cellWidth
        height: gridView.cellHeight

        AppDelegate {
            id: appDelegate
            tabName: "Favourites"
            app: modelData
            rootWindow: gridView.rootWindow
            anchors.fill: parent
        }

        Rectangle {
            id: dragHandle
            width: 20
            height: 20
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            color: "#cccccc"
            radius: 10
            border.color: "#888"
            border.width: 1

            Text {
                anchors.centerIn: parent
                text: "\u2630"
                font.pixelSize: 14
            }

            MouseArea {
                anchors.fill: parent
                drag.target: delegateItem
                acceptedButtons: Qt.LeftButton

                onPressed: {
                    gridView.dragIndex = index;
                }
                onReleased: {
                    gridView.dragIndex = -1;
                }
                onPositionChanged: function (mouse) {
                    var pos = gridView.mapFromItem(delegateItem, mouse.x, mouse.y);
                    var toIndex = gridView.indexAt(pos.x, pos.y);
                    if (toIndex !== -1 && toIndex !== index && gridView.dragIndex === index) {
                        appLauncher.move_favourite(index, toIndex);
                        gridView.dragIndex = toIndex;
                    }
                }
            }
        }
    }
}
