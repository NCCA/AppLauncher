#!/usr/bin/env -S uv run --script
import json
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Any, Dict, List, Union

from PySide6.QtCore import Property, QObject, QSettings, QUrl, Signal, Slot
from PySide6.QtGui import QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication, QDialog, QTextEdit, QVBoxLayout

import resources_rc  # noqa: F401 qt resource


class AppLauncher(QObject):
    """
    AppLauncher provides methods to launch applications, manage favourites,
    and search for apps. It exposes slots for QML integration.
    """

    # signals for QML
    favourites_changed = Signal()
    debug_output = Signal(str)
    status_changed = Signal(str)
    theme_changed = Signal(str)

    def __init__(self, apps_by_tab: List[Dict[str, Any]]) -> None:
        """
        Initialize the AppLauncher.

        Args:
            apps_by_tab: List of dictionaries, each representing a tab with its apps.
        """
        super().__init__()
        self._apps_by_tab: List[Dict[str, Any]] = apps_by_tab
        self._settings: QSettings = QSettings("YourCompany", "AppLauncher")
        self._favourites: List[Dict[str, Any]] = self._load_favourites()
        self._disk_quotas: List[Dict[str, Union[float, str]]] = []
        self._create_disk_quotas()
        self._theme = self._settings.value("user/theme", "System")  # Default to System

    @Property(str, notify=theme_changed)
    def theme(self):
        return self._theme

    @Slot(str)
    def set_theme(self, theme: str):
        if theme != self._theme:
            self._theme = theme
            self._settings.setValue("user/theme", theme)
            self.theme_changed.emit(theme)

    def _create_disk_quotas(self):
        self._disk_quotas = []
        self._disk_quotas.append(self._get_user_quota())
        self._disk_quotas.append(self._get_transfer_usage())

    def _get_user_quota(self):
        user = subprocess.getoutput("whoami")
        try:
            output = subprocess.check_output(["quota", "-u", "-s", user], text=True)
            data = output.strip().splitlines()
            numbers = data[3].split()
            return {
                "location": Path.home().as_posix(),
                "used": int(numbers[0][:-1]),
                "quota": int(numbers[1][:-1]),
                "limit": int(numbers[2][:-1]),  # strip G
            }
        except Exception as e:
            print("Error:", e)
        return None

    def _get_transfer_usage(self):
        gb = 1024**3  # 1 GB in bytes

        try:
            usage = shutil.disk_usage("/transfer")
            return {
                "location": "/transfer",
                "limit": round(usage.total / gb, 2),
                "used": round(usage.used / gb, 2),
                "quota": round(usage.free / gb, 2),
            }
        except FileNotFoundError:
            return {
                "location": "/dummydata",
                "limit": round(50 / gb, 2),
                "used": round(200 / gb, 2),
                "quota": round(220 / gb, 2),
            }

    @Property("QVariantList", constant=True)
    def diskQuotas(self):
        return self._disk_quotas

    # @Slot(str, str)
    # def launch_app(self, path: str, execName: str, flags=None, popup=False) -> None:
    #     if flags is None:
    #         flags = []
    #     try:
    #         app_name = execName  # Default to execName
    #         # Try to find the app name from the apps list
    #         for tab in self._apps_by_tab:
    #             for app in tab["apps"]:
    #                 if app["execName"] == execName and app["path"] == path:
    #                     app_name = app["name"]
    #                     break

    #         self.status_changed.emit(f"Launching {app_name}...")

    #         process = subprocess.Popen(
    #             [f"{path}/{execName}"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1
    #         )

    #         def read_output():
    #             for line in process.stdout:
    #                 self.debug_output.emit(line.rstrip())
    #             process.stdout.close()
    #             process.wait()
    #             self.debug_output.emit(f"Process exited with code {process.returncode}")
    #             self.status_changed.emit("Done.")

    #         import threading

    #         threading.Thread(target=read_output, daemon=True).start()

    #     except Exception as e:
    #         self.debug_output.emit(f"Failed to launch: {e}")
    #     self.status_changed.emit("App Launched")

    @Slot(str, str, "QVariantList", bool)
    def launch_app(self, path, execName, flags=None, popup=False):
        if flags is None:
            flags = []
        try:
            cmd = [f"{path}/{execName}"] + flags
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1)
            if popup:
                dlg = QDialog()
                dlg.setWindowTitle("Debug Output")
                layout = QVBoxLayout(dlg)
                textEdit = QTextEdit()
                textEdit.setReadOnly(False)  # Allow selection and pasting
                layout.addWidget(textEdit)
                dlg.setLayout(layout)

                def read_output():
                    for line in proc.stdout:
                        textEdit.append(line.rstrip())
                    proc.stdout.close()

                threading.Thread(target=read_output, daemon=True).start()
                dlg.show()
        except Exception as e:
            print(f"Failed to launch: {e}")

    @Slot(str)
    def emit_debug(self, text: str):
        """Emit debug output to QML."""
        self.debug_output.emit(text)

    @Slot(str, result="QVariantList")
    def search_apps(self, query: str) -> List[Dict[str, Any]]:
        """
        Search for applications whose names contain the query string.

        Args:
            query: The search query.

        Returns:
            A list of app dictionaries matching the query.
        """
        query = query.strip().lower()
        if not query:
            return []
        matches: List[Dict[str, Any]] = []
        for tab in self._apps_by_tab:
            for app in tab["apps"]:
                if query in app["name"].lower():
                    matches.append(app)
        return matches

    @Slot(int, int)
    def move_favourite(self, from_index: int, to_index: int) -> None:
        """
        Move a favourite app from one position to another.
        """
        if 0 <= from_index < len(self._favourites) and 0 <= to_index < len(self._favourites):
            fav = self._favourites.pop(from_index)
            self._favourites.insert(to_index, fav)
            self._save_favourites()
            self.favourites_changed.emit()

    @Slot(str)
    def add_to_favourites(self, appName: str) -> None:
        """
        Add an application to the favourites list by name.

        Args:
            appName: The name of the application to add.
        """
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
                    self.favourites_changed.emit()
                    return

    @Slot(str)
    def remove_from_favourites(self, appName: str) -> None:
        """
        Remove an application from the favourites list by name.

        Args:
            appName: The name of the application to remove.
        """
        for fav in self._favourites:
            if fav["name"] == appName:
                self._favourites.remove(fav)
                self._save_favourites()
                self.favourites_changed.emit()
                return

    def get_tabs_model(self) -> List[Dict[str, Any]]:
        """
        Get the model for tabs, including the Favourites tab.

        Returns:
            A list of tab dictionaries, with Favourites as the first tab.
        """
        tabs = [{"tabName": "Favourites", "apps": self._favourites}] + self._apps_by_tab
        return tabs

    def _load_favourites(self) -> List[Dict[str, Any]]:
        """
        Load the favourites list from QSettings.

        Returns:
            A list of favourite app dictionaries.
        """
        favs = self._settings.value("user/favourites", [])
        # QSettings may return a QVariantList of QVariantMaps, ensure Python dicts
        return [dict(fav) for fav in favs] if favs else []

    def _save_favourites(self) -> None:
        """
        Save the current favourites list to QSettings.
        """
        self._settings.setValue("user/favourites", self._favourites)


def load_apps_json(json_path: str) -> List[Dict[str, Any]]:
    """
    Load applications from a JSON file and organize them by tab.

    Args:
        json_path: Path to the JSON file.

    Returns:
        A list of tab dictionaries, each containing a list of apps.
    """
    with open(json_path, "r", encoding="utf-8") as f:
        data = json.load(f)
    tabs = {}
    for app_name, entry in data.items():
        app = dict(entry)
        app["name"] = app_name
        app["popup"] = app.get("popup", False)
        app["flags"] = app.get("flags", [])
        tab_name = app["tabName"]
        if tab_name not in tabs:
            tabs[tab_name] = []
        tabs[tab_name].append(app)
    return [{"tabName": tab, "apps": apps} for tab, apps in tabs.items()]


if __name__ == "__main__":
    app = QApplication(sys.argv)
    apps_by_tab = load_apps_json("apps.json")
    app_launcher = AppLauncher(apps_by_tab)
    engine = QQmlApplicationEngine()
    engine.rootContext().setContextProperty("appLauncher", app_launcher)
    engine.rootContext().setContextProperty("tabsModel", app_launcher.get_tabs_model())
    engine.rootContext().setContextProperty("diskQuotas", app_launcher._disk_quotas)
    engine.rootContext().setContextProperty("theme", app_launcher._theme)
    engine.load(QUrl("qrc:/qml/main.qml"))

    # Update QML model when favourites change
    def update_tabs_model() -> None:
        """
        Update the QML context property for the tabs model when favourites change.
        """
        engine.rootContext().setContextProperty("tabsModel", app_launcher.get_tabs_model())

    app_launcher.favourites_changed.connect(update_tabs_model)

    root_objects = engine.rootObjects()
    root = root_objects[0]
    debug_output = root.findChild(QObject, "debugOutput")

    def append_debug_output(text):
        if debug_output:
            debug_output.appendText(text)

    app_launcher.debug_output.connect(append_debug_output)

    status_bar = root.findChild(QObject, "statusBar")
    status_label = status_bar.findChild(QObject, "statusLabel")

    def set_status(text):
        if status_label:
            status_label.setProperty("text", text)

    app_launcher.status_changed.connect(set_status)
    # this needs to be loaded locally for menu bars etc.
    app.setWindowIcon(QIcon("./appsereicon.png"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
