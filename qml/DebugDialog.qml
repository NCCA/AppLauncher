import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

Dialog {
    id: debugDialog
    title: "Debug Output"
    modal: false
    standardButtons: Dialog.Close
    visible: false
    width: Math.min(700, parent ? parent.width * 0.8 : 700)
    height: Math.min(400, parent ? parent.height * 0.6 : 400)

    property alias debugText: debugTextArea.text

    // Center the dialog when it becomes visible
    onVisibleChanged: {
        var win = parent || Qt.application.activeWindow;
        if (visible && win) {
            x = win.x + (win.width - width) / 2;
            y = win.y + (win.height - height) / 2;
        }
    }

    contentItem: TextArea {
        id: debugTextArea
        readOnly: false
        wrapMode: TextArea.Wrap
        selectByMouse: true
        selectByKeyboard: true
        font.family: "monospace"
        font.pixelSize: 14
        text: ""
    }

    onAccepted: visible = false
    onRejected: visible = false
}
