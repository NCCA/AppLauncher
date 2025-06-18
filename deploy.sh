#!/usr/bin/env bash
    
pyside6-rcc resources.rcc -o resources_rc.py
uv run pyinstaller --onefile --windowed --add-data 'resources_rc.py:.' --add-data 'apps.json:.' main.py --name AppsEre
cp dist/AppsEre /public/devel/25-26/AppsEre
cp apps.json /public/devel/25-26/AppsEre
cp appsereicon.png  /public/devel/25-26/AppsEre