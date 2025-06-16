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

    cellWidth: 100
    cellHeight: 100

    // The model should be set from outside this component (e.g., main.qml)
    model: model

    // Index of the currently dragged item, -1 if none
    property int dragIndex: -1

    delegate: Item {
        id: delegateItem
        width: gridView.cellWidth
        height: gridView.cellHeight

        // App icon and label
        AppDelegate {
            id: appDelegate
            tabName: "Favourites"
            app: modelData
            anchors.fill: parent
        }

        // Drag handle in the bottom-right corner for reordering
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
                text: "\u2630" // Unicode for drag handle
                font.pixelSize: 14
            }

            MouseArea {
                anchors.fill: parent
                drag.target: delegateItem
                acceptedButtons: Qt.LeftButton

                // Start dragging
                onPressed: {
                    gridView.dragIndex = index;
                }
                // Stop dragging
                onReleased: {
                    gridView.dragIndex = -1;
                }
                // Handle drag movement and reorder items
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
