import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

/**
 * DebugOutput.qml
 *
 * Displays debug output in a scrollable text area with a clear button.
 * Use the appendText(text) method to add output.
 */

Item {
    id: debugOutput
    property alias text: debugArea.text
    objectName: "debugOutput"
    signal cleared

    width: 600
    height: 300

    Rectangle {
        anchors.fill: parent
        color: "#222"
        radius: 8
        border.color: "#888"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            spacing: 8

            TextArea {
                id: debugArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                readOnly: true
                wrapMode: TextArea.Wrap
                color: "#fff"
                font.family: "monospace"
                background: Rectangle {
                    color: "#333"
                }
            }

            Button {
                text: "Clear"
                Layout.alignment: Qt.AlignRight
                onClicked: {
                    debugArea.text = "";
                    debugOutput.cleared();
                }
            }
        }
    }

    function appendText(msg) {
        debugArea.text += msg + "\n";
    }
}
