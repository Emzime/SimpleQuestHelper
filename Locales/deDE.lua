-- ===================================================
-- SimpleQuestHelper - Locales/deDE.lua
-- Deutsche Lokalisierung
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestHelper then SimpleQuestHelper = {} end
if not SimpleQuestHelper.Locales then SimpleQuestHelper.Locales = {} end

SimpleQuestHelper.Locales["deDE"] = {
    PREFIX = "|cFF00CCFF[SQH]|r",
    COMPLETED = "Quest abgeschlossen!",
    ENABLED = "Aktiviert",
    DISABLED = "Deaktiviert",
    AUTO_ACCEPT_ON = "Auto-Annahme aktiviert",
    AUTO_ACCEPT_OFF = "Auto-Annahme deaktiviert",
    AUTO_COMPLETE_ON = "Auto-Abschluss aktiviert",
    AUTO_COMPLETE_OFF = "Auto-Abschluss deaktiviert",
    HELP = "Verwendung: /sqh on|off",
    TOOLTIP_TITLE = "Simple Quest Helper",
    TOOLTIP_LEFT_CLICK = "Linksklick: Ankündigungen ein/aus",
    TOOLTIP_LEFT_SHIFT = "Shift+Linksklick: Sprache ändern",
    TOOLTIP_LEFT_ALT = "Alt+Linksklick: Quests scannen",
    TOOLTIP_RIGHT_CLICK = "Rechtsklick: Auto-Annahme ein/aus",
    TOOLTIP_RIGHT_SHIFT = "Shift+Rechtsklick: Auto-Abschluss ein/aus",
    TOOLTIP_RIGHT_ALT = "Alt+Rechtsklick: Cache löschen",
    TOOLTIP_STATUS_ANNOUNCE = "Ankündigungen",
    TOOLTIP_STATUS_AUTOACCEPT = "Auto-Annahme",
    TOOLTIP_STATUS_AUTOCOMPLETE = "Auto-Abschluss",
    TOOLTIP_ON = "EIN",
    TOOLTIP_OFF = "AUS",
    TOOLTIP_ACTIVATE = "Aktivieren",
    TOOLTIP_DEACTIVATE = "Deaktivieren",
    TOOLTIP_CHANGE_LANG = "Sprache ändern",
    TOOLTIP_SCAN_QUESTS = "Quests scannen",
    TOOLTIP_CLEAR_CACHE = "Cache löschen",
    TOOLTIP_STATUS = "Status",
    LANG_SET = "Sprache eingestellt auf",
    BUTTON_EXISTS = "Button existiert bereits",
    BUTTON_CREATED = "Button erstellt",
    SCAN_START = "Scanne Questlog...",
    SCAN_END = "Scan abgeschlossen",
    LANG_LIST = "Verfügbare Sprachen:",
    LANG_USAGE = "Verwendung: /sqh lang [Nummer]",
    CMD_HELP = "|cFF00CCFF=== Simple Quest Helper Befehle ===|r",
    CMD_ON = "|cFF00FF00/sqh on|r - Ankündigungen aktivieren",
    CMD_OFF = "|cFFFF0000/sqh off|r - Ankündigungen deaktivieren",
    CMD_LANG = "|cFFFFFF00/sqh lang|r - Sprache ändern",
    CMD_BUTTON = "|cFF00FFFF/sqh button|r - Button neu erstellen",
    CMD_SCAN = "|cFFFF9900/sqh scan|r - Quests scannen",
    CMD_AUTO_ACCEPT = "|cFF00FF00/sqh autoaccept|r - Auto-Annahme ein/aus",
    CMD_AUTO_COMPLETE = "|cFF00FF00/sqh autocomplete|r - Auto-Abschluss ein/aus",
    CMD_HELP_TEXT = "|cFFCC00CC/sqh help|r - Diese Hilfe anzeigen",
    UNKNOWN_CMD = "Unbekannter Befehl. Tippe |cFF00CCFF/sqh help|r",
    LOADED = "|cFF00CCFFSimple Quest Helper v1.2|r geladen",
    TYPE_HELP = "Tippe |cFF00CCFF/sqh help|r für Befehle",
    CACHE_CLEARED = "Quest-Cache geleert",
    CACHE_CLEANED = "Cache bereinigt"
}
