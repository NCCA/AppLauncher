#!/usr/bin/env -S uv run --script
#
import json
import os
import sys

from PySide6.QtCore import Property, QObject, QUrl, Signal, Slot
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication, QFileDialog


class AppModel(QObject):
    appsChanged = Signal()
    filePathChanged = Signal()

    def __init__(self):
        super().__init__()
        self._apps = {}  # {name: {fields...}}
        self._file_path = ""

    @Property("QVariant", notify=appsChanged)
    def apps(self):
        return self._apps

    @Property(str, notify=filePathChanged)
    def filePath(self):
        return self._file_path

    @Slot(str)
    def loadJson(self, path):
        if not path:
            return
        try:
            with open(path, "r", encoding="utf-8") as f:
                self._apps = json.load(f)
            self._file_path = path
            self.appsChanged.emit()
            self.filePathChanged.emit()
        except Exception as e:
            print(f"Failed to load: {e}")

    @Slot()
    def openJsonDialog(self):
        dialog = QFileDialog()
        dialog.setFileMode(QFileDialog.ExistingFile)
        dialog.setNameFilter("JSON Files (*.json)")
        if dialog.exec():
            files = dialog.selectedFiles()
            if files:
                self.loadJson(files[0])

    @Slot()
    def saveJson(self):
        if not self._file_path:
            self.saveJsonAs()
            return
        try:
            with open(self._file_path, "w", encoding="utf-8") as f:
                json.dump(self._apps, f, indent=2)
            print(f"Saved to {self._file_path}")
        except Exception as e:
            print(f"Failed to save: {e}")

    @Slot()
    def saveJsonAs(self):
        dialog = QFileDialog()
        dialog.setAcceptMode(QFileDialog.AcceptSave)
        dialog.setNameFilter("JSON Files (*.json)")
        if dialog.exec():
            files = dialog.selectedFiles()
            if files:
                self._file_path = files[0]
                self.filePathChanged.emit()
                self.saveJson()

    @Slot(str, "QVariant")
    def updateApp(self, name, appdata):
        self._apps[name] = appdata
        self.appsChanged.emit()

    @Slot(str)
    def removeApp(self, name):
        if name in self._apps:
            del self._apps[name]
            self.appsChanged.emit()

    @Slot("QVariant")
    def addApp(self, appdata):
        name = appdata.get("name", "")
        if name:
            self._apps[name] = appdata
            self.appsChanged.emit()

    @Slot(result="QVariant")
    def getAppNames(self):
        return list(self._apps.keys())

    @Slot(str, result="QVariant")
    def getApp(self, name):
        return self._apps.get(name, {})


def main():
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()

    model = AppModel()
    # Load from command line if provided
    if len(sys.argv) > 1 and os.path.exists(sys.argv[1]):
        model.loadJson(sys.argv[1])

    engine.rootContext().setContextProperty("appModel", model)
    engine.load(QUrl.fromLocalFile(("Editor.qml")))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())


if __name__ == "__main__":
    main()
