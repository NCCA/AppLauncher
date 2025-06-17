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
    signal search(string query)
    signal clear

    property int theme: Material.theme

    TextField {
        id: searchField
        Layout.fillWidth: true
        placeholderText: "Search apps..."
        onTextChanged: search(text)
        // Theme-aware colors
        background: Rectangle {
            color: theme === Material.Dark ? "#232323" : "#fff"
            radius: 4
        }
        color: theme === Material.Dark ? "#fff" : "#222"
        // Optionally, set placeholder text color
        placeholderTextColor: theme === Material.Dark ? "#bbb" : "#888"
    }

    Button {
        text: "Clear"
        visible: searchField.text.length > 0
        onClicked: {
            searchField.text = "";
            clear();
        }
    }
}
