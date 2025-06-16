import QtQuick 2.15
import QtQuick.Controls 2.15

GridView {
    id: gridView
    cellWidth: 100
    cellHeight: 100
    model: model // set from main.qml

    property int dragIndex: -1

    delegate: Item {
        id: delegateItem
        width: gridView.cellWidth
        height: gridView.cellHeight

        AppDelegate {
            id: appDelegate
            tabName: "Favourites"
            app: modelData
            anchors.fill: parent
        }

        // Drag handle in the corner for reordering
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
