import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

RowLayout {
    signal search(string query)
    signal clear

    TextField {
        id: searchField
        Layout.fillWidth: true
        placeholderText: "Search apps..."
        onTextChanged: search(text)
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
