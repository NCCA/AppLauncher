import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

/**
 * SearchBar.qml
 *
 * A simple search bar component with a text field and a clear button.
 * Emits 'search' signal on text change and 'clear' signal when cleared.
 */

RowLayout {
    // Signal emitted when the search text changes
    signal search(string query)
    // Signal emitted when the search is cleared
    signal clear

    // Text field for entering search queries
    TextField {
        id: searchField
        Layout.fillWidth: true
        placeholderText: "Search apps..."
        onTextChanged: search(text)
    }

    // Button to clear the search field
    Button {
        text: "Clear"
        visible: searchField.text.length > 0
        onClicked: {
            searchField.text = "";
            clear();
        }
    }
}
