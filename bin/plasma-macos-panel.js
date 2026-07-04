// Niri-style top bar + WaveTask macOS dock

var allPanels = panels();
var topPanel = null;
var dockPanel = null;

for (var i = 0; i < allPanels.length; i++) {
    if (allPanels[i].location === "top") topPanel = allPanels[i];
    if (allPanels[i].location === "bottom") dockPanel = allPanels[i];
}

function panelHas(panel, type) {
    var ws = panel.widgets();
    for (var j = 0; j < ws.length; j++) {
        if (ws[j].type === type) return ws[j];
    }
    return null;
}

if (topPanel) {
    topPanel.location = "top";
    topPanel.floating = false;
    topPanel.alignment = "left";
    topPanel.hiding = false;
    topPanel.height = Math.round(gridUnit * 1.35);
    topPanel.minimumLength = 0;
    topPanel.maximumLength = 9999;

    topPanel.writeConfig("backgroundHints", 4);
    topPanel.writeConfig("userBackgroundHints", 4);
    topPanel.writeConfig("opacityMode", 2);

    var removeTop = [
        "org.kde.plasma.appmenu",
        "org.kde.plasma.showdesktop",
        "org.kde.plasma.marginsseparator",
        "org.kde.milou",
        "org.kde.plasma.pager",
        "org.kde.plasma.icontasks"
    ];
    var tw = topPanel.widgets();
    for (var t = tw.length - 1; t >= 0; t--) {
        if (removeTop.indexOf(tw[t].type) !== -1) tw[t].remove();
    }

    if (!panelHas(topPanel, "dev.xarbit.appgrid.panel") && !panelHas(topPanel, "org.kde.plasma.kickoff")) {
        topPanel.addWidget("dev.xarbit.appgrid.panel");
    }
    if (!panelHas(topPanel, "org.kde.plasma.activewindow")) {
        topPanel.addWidget("org.kde.plasma.activewindow");
    }
    if (!panelHas(topPanel, "org.kde.plasma.panelspacer")) {
        topPanel.addWidget("org.kde.plasma.panelspacer");
    }
    if (!panelHas(topPanel, "org.kde.plasma.mediacontroller")) {
        topPanel.addWidget("org.kde.plasma.mediacontroller");
    }
    if (!panelHas(topPanel, "org.kde.plasma.systemtray")) {
        topPanel.addWidget("org.kde.plasma.systemtray");
    }
    if (!panelHas(topPanel, "org.kde.plasma.digitalclock")) {
        topPanel.addWidget("org.kde.plasma.digitalclock");
    }

    tw = topPanel.widgets();
    for (var k = 0; k < tw.length; k++) {
        var w = tw[k];
        if (w.type === "dev.xarbit.appgrid.panel") {
            w.currentConfigGroup = ["Configuration", "General"];
            w.writeConfig("useCustomButtonImage", true);
            w.writeConfig("customButtonImage", "file:///home/ar/.local/share/icons/apple-logo.svg");
            w.writeConfig("menuLabel", "");
        }
        if (w.type === "org.kde.plasma.activewindow") {
            w.currentConfigGroup = ["Configuration", "General"];
            w.writeConfig("showIcon", false);
            w.writeConfig("noWindowText", "Desktop");
        }
        if (w.type === "org.kde.plasma.mediacontroller") {
            w.currentConfigGroup = ["Configuration", "General"];
            w.writeConfig("showAlbumCover", true);
            w.writeConfig("showTrackName", true);
            w.writeConfig("showArtistName", true);
            w.writeConfig("showControlButton", false);
        }
        if (w.type === "org.kde.plasma.digitalclock") {
            w.currentConfigGroup = ["Configuration", "Appearance"];
            w.writeConfig("dateFormat", "custom");
            w.writeConfig("customDateFormat", "ddd MMM d  HH:mm");
            w.writeConfig("use24hFormat", true);
            w.writeConfig("showSeconds", false);
            w.writeConfig("fontWeight", 400);
        }
    }
}

if (dockPanel) {
    dockPanel.location = "bottom";
    dockPanel.floating = true;
    dockPanel.alignment = "center";
    dockPanel.hiding = "autohide";
    dockPanel.height = 86;
    dockPanel.lengthMode = "fit";

    dockPanel.writeConfig("backgroundHints", 4);
    dockPanel.writeConfig("userBackgroundHints", 4);
    dockPanel.writeConfig("opacityMode", 2);

    var dw = dockPanel.widgets();
    for (var d = dw.length - 1; d >= 0; d--) {
        if (dw[d].type === "org.kde.plasma.icontasks") dw[d].remove();
    }

    var tasks = panelHas(dockPanel, "org.vicko.wavetask");
    if (!tasks) tasks = dockPanel.addWidget("org.vicko.wavetask");

    tasks.currentConfigGroup = ["General"];
    tasks.writeConfig("skinName", "Tahoe Dark");
    tasks.writeConfig("iconSize", 46);
    tasks.writeConfig("magnification", 95);
    tasks.writeConfig("amplitud", 2.0);
    tasks.writeConfig("showReflection", true);
    tasks.writeConfig("groupingStrategy", 0);
    tasks.writeConfig("launchers", [
        "preferred://filemanager",
        "preferred://browser",
        "applications:Alacritty.desktop",
        "applications:code-oss.desktop",
        "applications:brave-browser.desktop"
    ]);
}