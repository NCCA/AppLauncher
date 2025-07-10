#!/usr/bin/env bash

pyside6-rcc resources.qrc -o resources_rc.py
uv run pyinstaller --onefile --windowed --add-data 'resources_rc.py:.' --add-data 'apps.json:.' main.py --name AppsEre
cp dist/AppsEre /public/devel/25-26/AppsEre
cp apps.json /public/devel/25-26/AppsEre
cp appsereicon.png  /public/devel/25-26/AppsEre
cp AppsEre.desktop /public/devel/25-26/AppsEre

# Note as I am now using QtWebEngine I need to deploy loads of extra runtime stuff as follows
# This can be copied from the .venv
# AppsEre          apps.json   qtwebengine_devtools_resources.pak  qtwebengine_resources_200p.pak
# AppsEre.desktop  icudtl.dat  QtWebEngineProcess                  qtwebengine_resources.pak
#appsereicon.png  locales     qtwebengine_resources_100p.pak      v8_context_snapshot.bin
# Note some of this is generated on first launch as well.
