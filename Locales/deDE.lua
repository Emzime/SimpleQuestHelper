-- ===================================================
-- SimpleQuestAnnouncer - Locales/deDE.lua
-- Localisation allemande
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestAnnouncer then SimpleQuestAnnouncer = {} end
if not SimpleQuestAnnouncer.Locales then SimpleQuestAnnouncer.Locales = {} end

SimpleQuestAnnouncer.Locales["deDE"] = {
    PREFIX = "|cFF00CCFF[SQA]|r",
    COMPLETED = "Quest abgeschlossen!",
    ENABLED = "Aktiviert",
    DISABLED = "Deaktiviert",
    HELP = "Verwendung: /sqa on|off",
    TOOLTIP_LEFT = "Linksklick: Ein/Aus",
    TOOLTIP_RIGHT = "Rechtsklick: Sprachmenü",
    TOOLTIP_STATUS = "Status",
    LANG_SET = "Sprache eingestellt auf",
    BUTTON_EXISTS = "Button existiert bereits",
    BUTTON_CREATED = "Button erstellt",
    SCAN_START = "Questlog wird durchsucht...",
    SCAN_END = "Scan abgeschlossen",
    LANG_LIST = "Verfügbare Sprachen:",
    LANG_USAGE = "Verwendung: /sqa lang [Nummer]",
    CMD_HELP = "|cFF00CCFF=== Simple Quest Announcer Befehle ===|r",
    CMD_ON = "|cFF00FF00/sqa on|r - Ankündigungen aktivieren",
    CMD_OFF = "|cFFFF0000/sqa off|r - Ankündigungen deaktivieren",
    CMD_LANG = "|cFFFFFF00/sqa lang|r - Sprache ändern",
    CMD_BUTTON = "|cFF00FFFF/sqa button|r - Button neu erstellen",
    CMD_SCAN = "|cFFFF9900/sqa scan|r - Quests scannen",
    CMD_HELP_TEXT = "|cFFCC00CC/sqa help|r - Diese Hilfe anzeigen",
    UNKNOWN_CMD = "Unbekannter Befehl. Tippe |cFF00CCFF/sqa help|r",
    LOADED = "|cFF00CCFFSimple Quest Announcer v1.0|r geladen",
    TYPE_HELP = "Tippe |cFF00CCFF/sqa help|r für Befehle",
    CACHE_CLEARED = "Quest-Cache gelöscht",
    CACHE_CLEANED = "Cache bereinigt",
    SILENT_MODE = "Stiller Modus für",
    ANNOUNCEMENTS_ENABLED = "Ankündigungen aktiviert",
    NOT_INITIALIZED = "Noch nicht initialisiert",
    SECONDS = "Sekunden"
}
