import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Window 2.15

Window {
    id: aboutWindow
    property string aboutText: ""
    property int theme: Material.theme
    width: 600
    height: 400
    visible: false
    flags: Qt.Dialog | Qt.WindowTitleHint | Qt.WindowCloseButtonHint
    title: "About"

    color: theme === Material.Dark ? "#222" : "#fff"

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        ScrollView {
            id: scroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Text {
                id: aboutTextItem
                text: aboutWindow.aboutText
                wrapMode: Text.WordWrap
                textFormat: theme === Material.Dark ? Text.RichText : Text.MarkdownText
                color: theme === Material.Dark ? "#fff" : "#222"
                width: scroll.availableWidth
                // anchors.left/right are not needed if width is set
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        Button {
            text: "Close"
            Layout.alignment: Qt.AlignRight
            onClicked: aboutWindow.close()
        }
    }

    function openWithText(text) {
        aboutWindow.aboutText = text
        aboutWindow.visible = true
    }
    function closeWithClear() {
        aboutWindow.visible = false
        aboutWindow.aboutText = ""
    }
}
