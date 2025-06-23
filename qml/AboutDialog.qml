import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Window 2.15

Window {
    id: aboutWindow
    property string aboutText: ""
    property int theme: Material.theme
    width: 400
    height: 300
    visible: false
    flags: Qt.Dialog | Qt.WindowTitleHint | Qt.WindowCloseButtonHint
    title: "About"

    color: theme === Material.Dark ? "#222" : "#fff"

    // Top-level Item for focus and key handling
    Item {
        id: contentRoot
        anchors.fill: parent
        focus: true

        Keys.onReleased: {
            if (event.key === Qt.Key_Escape) {
                aboutWindow.close()
                event.accepted = true
            }
        }

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
                    onLinkActivated: Qt.openUrlExternally(link)
                }
            }

            Button {
                text: "Close"
                Layout.alignment: Qt.AlignRight
                onClicked: aboutWindow.close()
            }
        }
    }

    function openWithText(text) {
        aboutWindow.aboutText = text
        aboutWindow.visible = true
        contentRoot.forceActiveFocus()
    }
    function closeWithClear() {
        aboutWindow.visible = false
        aboutWindow.aboutText = ""
    }
}
