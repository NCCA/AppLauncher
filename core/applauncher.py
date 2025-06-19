import shutil
import subprocess
from pathlib import Path
from typing import Any, Dict, List, Optional, Union

from PySide6.QtCore import Property, QObject, QSettings, Signal, Slot


class AppLauncher(QObject):
    """
    AppLauncher provides methods to launch applications, manage favourites,
    and search for apps. It exposes slots for QML integration.
    """

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
        self._theme: str = str(self._settings.value("user/theme", "System"))  # Default to System
        self._debug_dialogs: List[Any] = []

    @Property(str, notify=theme_changed)
    def theme(self) -> str:
        """
        The current theme as a string.
        """
        return self._theme

    @Slot(str)
    def set_theme(self, theme: str) -> None:
        """
        Set the current theme.

        Args:
            theme: The new theme to set.
        """
        if theme != self._theme:
            self._theme = theme
            self._settings.setValue("user/theme", theme)
            self.theme_changed.emit(theme)

    def _create_disk_quotas(self) -> None:
        """
        Populate the disk quotas list with user and transfer quotas.
        """
        self._disk_quotas = []
        user_quota = self._get_user_quota()
        if user_quota:
            self._disk_quotas.append(user_quota)
        transfer_quota = self._get_transfer_usage()
        if transfer_quota:
            self._disk_quotas.append(transfer_quota)

    def _get_user_quota(self) -> Optional[Dict[str, Union[str, int]]]:
        """
        Get the user's disk quota.

        Returns:
            A dictionary with quota information, or None if unavailable.
        """
        user = subprocess.getoutput("whoami")
        try:
            output = subprocess.check_output(["quota", "-u", "-s", user], text=True)
            data = output.strip().splitlines()
            numbers = data[3].split()
            return {
                "location": str(Path.home()),
                "used": int(numbers[0][:-1]),
                "quota": int(numbers[1][:-1]),
                "limit": int(numbers[2][:-1]),
            }
        except Exception as e:
            print("Error:", e)
        return None

    def _get_transfer_usage(self) -> Optional[Dict[str, Union[str, float]]]:
        """
        Get the disk usage for the /transfer directory.

        Returns:
            A dictionary with usage information, or None if unavailable.
        """
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
    def diskQuotas(self) -> List[Dict[str, Union[float, str]]]:
        """
        Property for disk quotas, exposed to QML.

        Returns:
            A list of disk quota dictionaries.
        """
        return self._disk_quotas

    @Slot(str, str, "QVariantList", bool)
    def launch_app(self, path: str, execName: str, flags: Optional[List[str]] = None, popup: bool = False) -> None:
        """
        Launch an application with optional flags and debug popup.

        Args:
            path: The directory path to the executable.
            execName: The name of the executable.
            flags: Optional list of command-line flags.
            popup: Whether to show the debug output dialog.
        """
        if flags is None:
            flags = []
        flags = [str(f) for f in flags]
        try:
            cmd = [f"{path}/{execName}"] + flags
            proc = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1)
            if popup:
                # Emit a signal to QML to open the debug dialog and clear previous output
                self.status_changed.emit("show_debug_dialog")

            def read_output() -> None:
                for line in proc.stdout:
                    self.debug_output.emit(line.rstrip())
                proc.stdout.close()

            import threading

            threading.Thread(target=read_output, daemon=True).start()
        except Exception as e:
            print(f"Failed to launch: {e}")

    @Slot(str)
    def emit_debug(self, text: str) -> None:
        """
        Emit debug output to QML.

        Args:
            text: The debug text to emit.
        """
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

        Args:
            from_index: The current index of the favourite.
            to_index: The new index to move to.
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
        for fav in self._favourites:
            if fav["name"] == appName:
                return
        for tab in self._apps_by_tab:
            for app in tab["apps"]:
                if app["name"] == appName:
                    # Ensure flags is always present
                    app_copy = dict(app)
                    app_copy["flags"] = list(app.get("flags", []))
                    self._favourites.append(app_copy)
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

    @Slot("QVariant")
    def create_desktop_entry(self, app):
        # Convert QJSValue to Python dict if needed
        if hasattr(app, "toVariant"):
            app = app.toVariant()
        try:
            desktop_entry = f"""
[Desktop Entry]
Type=Application
Name={app["name"]}
Exec={app["path"]}/{app["execName"]}
Icon={app["icon"]}
Terminal=false
"""
            print(f"{app["path"]=}/{app["execName"]=}")
            desktop_dir = Path.home() / "Desktop"
            desktop_dir.mkdir(exist_ok=True)
            filename = f"{app['name'].replace(' ', '_')}.desktop"
            filepath = desktop_dir / filename
            filepath.write_text(desktop_entry)
            filepath.chmod(0o755)
            self.status_changed.emit(f"Desktop shortcut created: {filepath}")
        except Exception as e:
            self.status_changed.emit(f"Failed to create shortcut: {e}")

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
        # QSettings may return a QVariantList of QVariantMaps, ensure Python dicts and flags
        return [dict(fav, flags=list(fav.get("flags", []))) for fav in favs] if favs else []

    def _save_favourites(self) -> None:
        """
        Save the current favourites list to QSettings.
        """
        self._settings.setValue("user/favourites", self._favourites)
