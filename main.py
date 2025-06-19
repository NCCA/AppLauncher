#!/usr/bin/env -S uv run --script
import json
import sys
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
    debug_output = root.findChild(object, "debugOutput")

    def append_debug_output(text):
        if debug_output:
            debug_output.appendText(text)

    app_launcher.debug_output.connect(append_debug_output)

    status_bar = root.findChild(object, "statusBar")
    status_label = status_bar.findChild(object, "statusLabel")

    def set_status(text):
        if status_label:
            status_label.setProperty("text", text)

    app_launcher.status_changed.connect(set_status)
    # this needs to be loaded locally for menu bars etc.
    app.setWindowIcon(QIcon("./appsereicon.png"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
