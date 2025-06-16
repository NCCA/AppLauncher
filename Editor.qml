import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs

ApplicationWindow {
    id: root
    visible: true
    width: 700
    height: 600
    title: "App JSON Editor"

    property bool isNew: false
    signal saveApp(var appdata)

    property string name: ""
    property string path: ""
    property string execName: ""
    property string desc: ""
    property string icon: ""
    property string tabName: ""

    FileDialog {
        id: pathDialog
        title: "Select Application Folder"
        fileMode: FileDialog.Directory
        onAccepted: root.path = fileUrl.toString().replace("file://", "")
    }
    FileDialog {
        id: execDialog
        title: "Select Executable"
        fileMode: FileDialog.OpenFile
        onAccepted: root.execName = fileUrl.toString().split("/").pop()
    }
    FileDialog {
        id: iconDialog
        title: "Select Icon"
        fileMode: FileDialog.OpenFile
        nameFilters: ["Images (*.png *.jpg *.svg)"]
        onAccepted: root.icon = fileUrl.toString().replace("file://", "")
    }

    function loadApp(appName) {
        var app = appModel.getApp(appName);
        name = app.name || appName;
        path = app.path || "";
        execName = app.execName || "";
        desc = app.desc || "";
        icon = app.icon || "";
        tabName = app.tabName || "";
    }
    function clearFields() {
        name = "";
        path = "";
        execName = "";
        desc = "";
        icon = "";
        tabName = "";
    }

    ColumnLayout {
        spacing: 4
        anchors.fill: parent

        RowLayout {
            Label {
                text: "Name:"
            }
            TextField {
                text: root.name
                onTextChanged: root.name = text
                Layout.fillWidth: true
            }
        }
        RowLayout {
            Label {
                text: "Path:"
            }
            TextField {
                text: root.path
                onTextChanged: root.path = text
                Layout.fillWidth: true
            }
            Button {
                text: "..."
                onClicked: pathDialog.open()
            }
        }
        RowLayout {
            Label {
                text: "Executable:"
            }
            TextField {
                text: root.execName
                onTextChanged: root.execName = text
                Layout.fillWidth: true
            }
            Button {
                text: "..."
                onClicked: execDialog.open()
            }
        }
        RowLayout {
            Label {
                text: "Icon:"
            }
            TextField {
                text: root.icon
                onTextChanged: root.icon = text
                Layout.fillWidth: true
            }
            Button {
                text: "..."
                onClicked: iconDialog.open()
            }
        }
        RowLayout {
            Label {
                text: "Tab:"
            }
            TextField {
                text: root.tabName
                onTextChanged: root.tabName = text
                Layout.fillWidth: true
            }
        }
        RowLayout {
            Label {
                text: "Description:"
            }
            TextEdit {
                text: root.desc
                onTextChanged: root.desc = text
                Layout.fillWidth: true
                wrapMode: TextEdit.WordWrap
            }
        }
        Button {
            text: root.isNew ? "Add App" : "Save Changes"
            onClicked: {
                saveApp({
                    name: root.name,
                    path: root.path,
                    execName: root.execName,
                    desc: root.desc,
                    icon: root.icon,
                    tabName: root.tabName
                });
            }
            Layout.alignment: Qt.AlignRight
        }
    }
}
