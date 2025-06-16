# Resource object code (Python 3)
# Created by: object code
# Created by: The Resource Compiler for Qt version 6.9.1
# WARNING! All changes made in this file will be lost!

from PySide6 import QtCore

qt_resource_data = b"\
\x00\x00\x05V\
i\
mport QtQuick 2.\
15\x0aimport QtQuic\
k.Controls 2.15\x0a\
import QtQuick.L\
ayouts 1.15\x0a\x0aLis\
tView {\x0a    id: \
searchResultsVie\
w\x0a    property v\
ar searchResults\
: []\x0a    Layout.\
fillWidth: true\x0a\
    Layout.prefe\
rredHeight: sear\
chResults.length\
 > 0 ? 120 : 0\x0a \
   model: search\
Results\x0a    visi\
ble: searchResul\
ts.length > 0\x0a  \
  delegate: Rect\
angle {\x0a        \
width: parent.wi\
dth\x0a        heig\
ht: 60\x0a        c\
olor: \x22#e0e0e0\x22\x0a\
        border.c\
olor: \x22#888\x22\x0a   \
     radius: 8\x0a \
       RowLayout\
 {\x0a            a\
nchors.fill: par\
ent\x0a            \
spacing: 12\x0a    \
        Image {\x0a\
                \
source: modelDat\
a.icon\x0a         \
       width: 40\
\x0a               \
 height: 40\x0a    \
            Layo\
ut.alignment: Qt\
.AlignVCenter\x0a  \
          }\x0a    \
        ColumnLa\
yout {\x0a         \
       Layout.al\
ignment: Qt.Alig\
nVCenter\x0a       \
         Text {\x0a\
                \
    text: modelD\
ata.name\x0a       \
             fon\
t.pixelSize: 16\x0a\
                \
    font.bold: t\
rue\x0a            \
    }\x0a          \
  }\x0a            \
Button {\x0a       \
         text: \x22\
Launch\x22\x0a        \
        onClicke\
d: appLauncher.l\
aunchApp(modelDa\
ta.path, modelDa\
ta.execName)\x0a   \
             Lay\
out.alignment: Q\
t.AlignVCenter\x0a \
           }\x0a   \
         Button \
{\x0a              \
  text: \x22Add to \
Favourites\x22\x0a    \
            onCl\
icked: appLaunch\
er.addToFavourit\
es(modelData.nam\
e)\x0a             \
   Layout.alignm\
ent: Qt.AlignVCe\
nter\x0a           \
 }\x0a        }\x0a   \
 }\x0a}\x0a\
\x00\x00\x03 \
i\
mport QtQuick 2.\
15\x0aimport QtQuic\
k.Controls 2.15\x0a\
import QtQuick.L\
ayouts 1.15\x0a\x0aIte\
m {\x0a    id: root\
\x0a    property st\
ring tabName: \x22\x22\
\x0a    property va\
r apps: []\x0a\x0a    \
GridView {\x0a     \
   id: gridView\x0a\
        anchors.\
fill: parent\x0a   \
     cellWidth: \
100\x0a        cell\
Height: 100\x0a    \
    model: apps\x0a\
\x0a        delegat\
e: AppDelegate {\
\x0a            tab\
Name: root.tabNa\
me\x0a            a\
pp: modelData\x0a  \
      }\x0a    }\x0a\x0a \
   // Show messa\
ge only if Favou\
rites tab and em\
pty\x0a    Text {\x0a \
       anchors.c\
enterIn: parent\x0a\
        visible:\
 root.tabName ==\
= \x22Favourites\x22 &\
& (!apps || apps\
.length === 0)\x0a \
       text: \x22No\
 favourites yet.\
\x5cnRight-click an\
y app and select\
 'Add to Favouri\
tes'.\x22\x0a        f\
ont.pixelSize: 1\
8\x0a        color:\
 \x22#888\x22\x0a        \
horizontalAlignm\
ent: Text.AlignH\
Center\x0a        w\
rapMode: Text.Wo\
rdWrap\x0a    }\x0a}\x0a\
\x00\x00\x06?\
i\
mport QtQuick 2.\
15\x0aimport QtQuic\
k.Controls 2.15\x0a\
\x0aRectangle {\x0a   \
 property string\
 tabName: \x22\x22\x0a   \
 property var ap\
p: {}\x0a\x0a    width\
: 90\x0a    height:\
 90\x0a    color: \x22\
#f0f0f0\x22\x0a    bor\
der.color: \x22#888\
\x22\x0a    radius: 8\x0a\
\x0a    // ToolTip \
attached propert\
y\x0a    ToolTip.vi\
sible: mouseArea\
.containsMouse\x0a \
   ToolTip.text:\
 app.desc\x0a    To\
olTip.delay: 300\
\x0a\x0a    Image {\x0a  \
      source: ap\
p.icon\x0a        a\
nchors.centerIn:\
 parent\x0a        \
width: 48\x0a      \
  height: 48\x0a   \
 }\x0a    Text {\x0a  \
      text: app.\
name\x0a        anc\
hors.horizontalC\
enter: parent.ho\
rizontalCenter\x0a \
       anchors.b\
ottom: parent.bo\
ttom\x0a        anc\
hors.bottomMargi\
n: 8\x0a        fon\
t.pixelSize: 14\x0a\
        elide: T\
ext.ElideRight\x0a \
   }\x0a\x0a    MouseA\
rea {\x0a        id\
: mouseArea\x0a    \
    anchors.fill\
: parent\x0a       \
 acceptedButtons\
: Qt.LeftButton \
| Qt.RightButton\
\x0a        hoverEn\
abled: true\x0a\x0a   \
     onClicked: \
{\x0a            if\
 (mouse.button =\
== Qt.LeftButton\
) {\x0a            \
    appLauncher.\
launchApp(app.pa\
th, app.execName\
);\x0a            }\
\x0a        }\x0a     \
   onPressed: {\x0a\
            if (\
mouse.button ===\
 Qt.RightButton)\
 {\x0a             \
   contextMenu.p\
opup();\x0a        \
    }\x0a        }\x0a\
    }\x0a\x0a    Menu \
{\x0a        id: co\
ntextMenu\x0a      \
  MenuItem {\x0a   \
         text: \x22\
Add to Favourite\
s\x22\x0a            v\
isible: tabName \
!== \x22Favourites\x22\
\x0a            onT\
riggered: {\x0a    \
            appL\
auncher.addToFav\
ourites(app.name\
);\x0a            }\
\x0a        }\x0a     \
   MenuItem {\x0a  \
          text: \
\x22Remove from Fav\
ourites\x22\x0a       \
     visible: ta\
bName === \x22Favou\
rites\x22\x0a         \
   onTriggered: \
{\x0a              \
  appLauncher.re\
moveFromFavourit\
es(app.name);\x0a  \
          }\x0a    \
    }\x0a    }\x0a}\x0a\
\x00\x00\x01\xd6\
i\
mport QtQuick 2.\
15\x0aimport QtQuic\
k.Controls 2.15\x0a\
import QtQuick.L\
ayouts 1.15\x0a\x0aRow\
Layout {\x0a    sig\
nal search(strin\
g query)\x0a    sig\
nal clear()\x0a\x0a   \
 TextField {\x0a   \
     id: searchF\
ield\x0a        Lay\
out.fillWidth: t\
rue\x0a        plac\
eholderText: \x22Se\
arch apps...\x22\x0a  \
      onTextChan\
ged: search(text\
)\x0a    }\x0a    Butt\
on {\x0a        tex\
t: \x22Clear\x22\x0a     \
   visible: sear\
chField.text.len\
gth > 0\x0a        \
onClicked: {\x0a   \
         searchF\
ield.text = \x22\x22\x0a \
           clear\
()\x0a        }\x0a   \
 }\x0a}\x0a\
\x00\x00\x05m\
i\
mport QtQuick 2.\
15\x0aimport QtQuic\
k.Controls 2.15\x0a\
import QtQuick.L\
ayouts 1.15\x0a\x0aApp\
licationWindow {\
\x0a    visible: tr\
ue\x0a    width: 80\
0\x0a    height: 60\
0\x0a    title: \x22Ap\
p Launcher\x22\x0a\x0a   \
 property var se\
archResults: []\x0a\
\x0a    ColumnLayou\
t {\x0a        anch\
ors.fill: parent\
\x0a\x0a        Search\
Bar {\x0a          \
  id: searchBar\x0a\
            onSe\
arch: function (\
query) {\x0a       \
         if (que\
ry.trim().length\
 > 0) {\x0a        \
            sear\
chResults = appL\
auncher.searchAp\
ps(query);\x0a     \
           } els\
e {\x0a            \
        searchRe\
sults = [];\x0a    \
            }\x0a  \
          }\x0a    \
        onClear:\
 {\x0a             \
   searchResults\
 = [];\x0a         \
   }\x0a        }\x0a\x0a\
        SearchRe\
sultsView {\x0a    \
        id: sear\
chResultsView\x0a  \
          search\
Results: searchR\
esults\x0a        }\
\x0a\x0a        TabBar\
 {\x0a            i\
d: tabBar\x0a      \
      Layout.fil\
lWidth: true\x0a   \
         Repeate\
r {\x0a            \
    model: tabsM\
odel\x0a           \
     TabButton {\
\x0a               \
     text: model\
Data.tabName\x0a   \
             }\x0a \
           }\x0a   \
     }\x0a\x0a        \
StackLayout {\x0a  \
          id: st\
ackLayout\x0a      \
      Layout.fil\
lWidth: true\x0a   \
         Layout.\
fillHeight: true\
\x0a            cur\
rentIndex: tabBa\
r.currentIndex\x0a\x0a\
            Repe\
ater {\x0a         \
       model: ta\
bsModel\x0a        \
        AppGrid \
{\x0a              \
      tabName: m\
odelData.tabName\
\x0a               \
     apps: model\
Data.apps\x0a      \
          }\x0a    \
        }\x0a      \
  }\x0a    }\x0a}\x0a\
"

qt_resource_name = b"\
\x00\x03\
\x00\x00x<\
\x00q\
\x00m\x00l\
\x00\x15\
\x08l\x8b\x5c\
\x00S\
\x00e\x00a\x00r\x00c\x00h\x00R\x00e\x00s\x00u\x00l\x00t\x00s\x00V\x00i\x00e\x00w\
\x00.\x00q\x00m\x00l\
\x00\x0b\
\x08g\xc1\xfc\
\x00A\
\x00p\x00p\x00G\x00r\x00i\x00d\x00.\x00q\x00m\x00l\
\x00\x0f\
\x02\x01\x22\x5c\
\x00A\
\x00p\x00p\x00D\x00e\x00l\x00e\x00g\x00a\x00t\x00e\x00.\x00q\x00m\x00l\
\x00\x0d\
\x0b\xf4F\xdc\
\x00S\
\x00e\x00a\x00r\x00c\x00h\x00B\x00a\x00r\x00.\x00q\x00m\x00l\
\x00\x08\
\x08\x01Z\x5c\
\x00m\
\x00a\x00i\x00n\x00.\x00q\x00m\x00l\
"

qt_resource_struct = b"\
\x00\x00\x00\x00\x00\x02\x00\x00\x00\x01\x00\x00\x00\x01\
\x00\x00\x00\x00\x00\x00\x00\x00\
\x00\x00\x00\x00\x00\x02\x00\x00\x00\x05\x00\x00\x00\x02\
\x00\x00\x00\x00\x00\x00\x00\x00\
\x00\x00\x00X\x00\x00\x00\x00\x00\x01\x00\x00\x08~\
\x00\x00\x01\x97yv\x956\
\x00\x00\x00\x9c\x00\x00\x00\x00\x00\x01\x00\x00\x10\x9b\
\x00\x00\x01\x97yN\xaeS\
\x00\x00\x00<\x00\x00\x00\x00\x00\x01\x00\x00\x05Z\
\x00\x00\x01\x97yk\xef\xf9\
\x00\x00\x00\x0c\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\
\x00\x00\x01\x97yN6F\
\x00\x00\x00|\x00\x00\x00\x00\x00\x01\x00\x00\x0e\xc1\
\x00\x00\x01\x97yN\x12\x1b\
"

def qInitResources():
    QtCore.qRegisterResourceData(0x03, qt_resource_struct, qt_resource_name, qt_resource_data)

def qCleanupResources():
    QtCore.qUnregisterResourceData(0x03, qt_resource_struct, qt_resource_name, qt_resource_data)

qInitResources()
