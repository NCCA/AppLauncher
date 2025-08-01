import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

/**
 * AppGrid.qml
 *
 * Displays a grid of application icons using AppDelegate as the delegate.
 * The model is expected to be set externally.
 * The tabName property is passed to each delegate for context (e.g., "Favourites").
 */

GridView {
    id: gridView

    property string tabName: ""
    property var rootWindow

    Layout.fillWidth: true
    Layout.fillHeight: true
    cellWidth: 100
    cellHeight: 100

    delegate: AppDelegate {
        tabName: gridView.tabName
        app: modelData
        rootWindow: gridView.rootWindow
    }
}
