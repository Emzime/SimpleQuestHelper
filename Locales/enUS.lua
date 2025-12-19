-- ===================================================
-- SimpleQuestAnnouncer - Locales/enUS.lua
-- English localization
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestAnnouncer then SimpleQuestAnnouncer = {} end
if not SimpleQuestAnnouncer.Locales then SimpleQuestAnnouncer.Locales = {} end

SimpleQuestAnnouncer.Locales["enUS"] = {
    PREFIX = "|cFF00CCFF[SQA]|r",
    COMPLETED = "Quest Complete!",
    ENABLED = "Enabled",
    DISABLED = "Disabled",
    HELP = "Usage: /sqa on|off",
    TOOLTIP_LEFT = "Left click: Toggle on/off",
    TOOLTIP_RIGHT = "Right click: Language menu",
    TOOLTIP_STATUS = "Status",
    LANG_SET = "Language set to",
    BUTTON_EXISTS = "Button already exists",
    BUTTON_CREATED = "Button created",
    SCAN_START = "Scanning quest log...",
    SCAN_END = "Scan complete",
    LANG_LIST = "Available languages:",
    LANG_USAGE = "Usage: /sqa lang [number]",
    CMD_HELP = "|cFF00CCFF=== Simple Quest Announcer Commands ===|r",
    CMD_ON = "|cFF00FF00/sqa on|r - Enable announcements",
    CMD_OFF = "|cFFFF0000/sqa off|r - Disable announcements",
    CMD_LANG = "|cFFFFFF00/sqa lang|r - Change language",
    CMD_BUTTON = "|cFF00FFFF/sqa button|r - Recreate button",
    CMD_SCAN = "|cFFFF9900/sqa scan|r - Scan quests",
    CMD_HELP_TEXT = "|cFFCC00CC/sqa help|r - Show this help",
    UNKNOWN_CMD = "Unknown command. Type |cFF00CCFF/sqa help|r",
    LOADED = "|cFF00CCFFSimple Quest Announcer v1.0|r loaded",
    TYPE_HELP = "Type |cFF00CCFF/sqa help|r for commands",
    CACHE_CLEARED = "Quest cache cleared",
    CACHE_CLEANED = "Cache cleaned",
	SILENT_MODE = "Silent mode for",
    ANNOUNCEMENTS_ENABLED = "Announcements enabled",
    NOT_INITIALIZED = "Not initialized yet",
    SECONDS = "seconds"
}
