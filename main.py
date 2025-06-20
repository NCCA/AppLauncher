#!/usr/bin/env -S uv run --script
import json
import shutil
import sys
from pathlib import Path
from typing import Any, Dict, List

from PySide6.QtCore import QUrl
from PySide6.QtGui import QIcon
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtWidgets import QApplication

import resources_rc  # noqa: F401 qt resource
from core.applauncher import AppLauncher


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
        app["flags"] = list(app.get("flags", []))
        tab_name = app["tabName"]
        if tab_name not in tabs:
            tabs[tab_name] = []
        tabs[tab_name].append(app)
    return [{"tabName": tab, "apps": apps} for tab, apps in tabs.items()]


def check_for_menu():
    """
    see if the app has a menu item for the linux applications if not copy
    Note this is very specific to out build so not a universal function
    """
    menu_item = Path("~/.local/share/applications/AppsEre.desktop").expanduser()
    if not menu_item.exists():
        try:
            shutil.copy("/public/devel/25-26/AppsEre/AppsEre.desktop", menu_item)
        except Exception:
            pass


if __name__ == "__main__":
    check_for_menu()
    app = QApplication(sys.argv)
    apps_by_tab = load_apps_json("apps.json")
    # create the app launcher backend for our QML tools
    app_launcher = AppLauncher(apps_by_tab)
    # grab the QML engine.
    engine = QQmlApplicationEngine()
    # associate the qml data (context Properties) to our app_launcher class.
    # This basically makes python objects and data available to the QML UI.
    engine.rootContext().setContextProperty("appLauncher", app_launcher)
    engine.rootContext().setContextProperty("tabsModel", app_launcher.get_tabs_model())
    engine.rootContext().setContextProperty("diskQuotas", app_launcher._disk_quotas)
    engine.rootContext().setContextProperty("theme", app_launcher._theme)
    engine.load(QUrl("qrc:/qml/main.qml"))

    # closture to update QML model when favourites change
    def update_tabs_model() -> None:
        """
        Update the QML context property for the tabs model when favourites change.
        """
        engine.rootContext().setContextProperty("tabsModel", app_launcher.get_tabs_model())

    app_launcher.favourites_changed.connect(update_tabs_model)

    root_objects = engine.rootObjects()
    root = root_objects[0]
    debug_output = root.findChild(object, "debugOutput")

    # closure do append debut text to the hidden debug panel
    def append_debug_output(text):
        if debug_output:
            debug_output.appendText(text)

    app_launcher.debug_output.connect(append_debug_output)

    status_bar = root.findChild(object, "statusBar")
    status_label = status_bar.findChild(object, "statusLabel")

    # closure to set the status text on the status bar when output generated
    def set_status(text):
        if status_label:
            status_label.setProperty("text", text)

    app_launcher.status_changed.connect(set_status)
    # this needs to be loaded locally for menu bars etc as resources are not read by the system icon setup
    app.setWindowIcon(QIcon("./appsereicon.png"))
    # ensure we have a valid engine.
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
