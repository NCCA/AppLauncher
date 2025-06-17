#!/usr/bin/env bash
    
pyside6-rcc resources.rcc -o resources_rc.py
uv run pyinstaller --onefile --windowed --add-data 'resources_rc.py:.' --add-data 'apps.json:.' main.py --name AppsEre
