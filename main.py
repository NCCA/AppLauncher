#!/usr/bin/env -S uv run --script
import json
import subprocess
import sys

from PySide6.QtCore import QObject, QSettings, QUrl, Signal, Slot
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication

import resources_rc  # noqa: F401 qt resource


class AppLauncher(QObject):
    favouritesChanged = Signal()

    def __init__(self, apps_by_tab):
        super().__init__()
        self._apps_by_tab = apps_by_tab
        self._settings = QSettings("YourCompany", "AppLauncher")
        self._favourites = self._load_favourites()

    @Slot(str, str)
    def launchApp(self, path, execName):
        try:
            subprocess.Popen([f"{path}/{execName}"])
        except Exception as e:
            print(f"Failed to launch: {e}")

    @Slot(str, result="QVariantList")
    def searchApps(self, query):
        """Return a flat list of apps matching the query in their name."""
        query = query.strip().lower()
        if not query:
            return []
        matches = []
        for tab in self._apps_by_tab:
            for app in tab["apps"]:
                if query in app["name"].lower():
                    # Ensure 'name' is present in the result
                    matches.append(dict(app))  # Make a copy to be safe
        return matches

    @Slot(str)
    def addToFavourites(self, appName):
        # Avoid duplicates
        for fav in self._favourites:
            if fav["name"] == appName:
                return
        # Find app in all tabs
        for tab in self._apps_by_tab:
            for app in tab["apps"]:
                if app["name"] == appName:
                    self._favourites.append(app)
                    self._save_favourites()
                    self.favouritesChanged.emit()
                    return

    @Slot(str)
    def removeFromFavourites(self, appName):
        for fav in self._favourites:
            if fav["name"] == appName:
                self._favourites.remove(fav)
                self._save_favourites()
                self.favouritesChanged.emit()
                return

    def getTabsModel(self):
        # Insert Favourites tab at the front
        tabs = [{"tabName": "Favourites", "apps": self._favourites}] + self._apps_by_tab
        return tabs

    def _load_favourites(self):
        favs = self._settings.value("user/favourites", [])
        # QSettings may return a QVariantList of QVariantMaps, ensure Python dicts
        return [dict(fav) for fav in favs] if favs else []

    def _save_favourites(self):
        self._settings.setValue("user/favourites", self._favourites)


def load_apps_json(json_path):
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    tabs = {}
    for app_name, entry in data.items():
        # entry is now a dict with named fields
        app = dict(entry)
        app["name"] = app_name  # Add the name field for convenience
        tab_name = app["tabName"]
        if tab_name not in tabs:
            tabs[tab_name] = []
        tabs[tab_name].append(app)
    return [{"tabName": tab, "apps": apps} for tab, apps in tabs.items()]


if __name__ == "__main__":
    app = QApplication(sys.argv)
    apps_by_tab = load_apps_json("apps.json")
    appLauncher = AppLauncher(apps_by_tab)
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("appLauncher", appLauncher)
    engine.rootContext().setContextProperty("tabsModel", appLauncher.getTabsModel())
    engine.load(QUrl("qrc:/qml/main.qml"))

    # Update QML model when favourites change
    def updateTabsModel():
        engine.rootContext().setContextProperty("tabsModel", appLauncher.getTabsModel())

    appLauncher.favouritesChanged.connect(updateTabsModel)

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
