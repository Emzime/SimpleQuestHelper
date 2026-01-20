-- ===================================================
-- SimpleQuestHelper - Locales/enUS.lua
-- English localization
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestHelper then SimpleQuestHelper = {} end
if not SimpleQuestHelper.Locales then SimpleQuestHelper.Locales = {} end

SimpleQuestHelper.Locales["enUS"] = {
    PREFIX = "|cFF00CCFF[SQH]|r",
    COMPLETED = "Quest Complete!",
    ENABLED = "Enabled",
    DISABLED = "Disabled",
    AUTO_ACCEPT_ON = "Auto-accept enabled",
    AUTO_ACCEPT_OFF = "Auto-accept disabled",
    AUTO_COMPLETE_ON = "Auto-complete enabled",
    AUTO_COMPLETE_OFF = "Auto-complete disabled",
    HELP = "Usage: /sqh on|off",
    TOOLTIP_TITLE = "Simple Quest Helper",
    TOOLTIP_LEFT_CLICK = "Left click: Toggle announcements",
    TOOLTIP_LEFT_SHIFT = "Shift+Left click: Change language",
    TOOLTIP_LEFT_ALT = "Alt+Left click: Scan quests",
    TOOLTIP_RIGHT_CLICK = "Right click: Toggle auto-accept",
    TOOLTIP_RIGHT_SHIFT = "Shift+Right click: Toggle auto-complete",
    TOOLTIP_RIGHT_ALT = "Alt+Right click: Clear cache",
    TOOLTIP_STATUS_ANNOUNCE = "Announcements",
    TOOLTIP_STATUS_AUTOACCEPT = "Auto-accept",
    TOOLTIP_STATUS_AUTOCOMPLETE = "Auto-complete",
    TOOLTIP_ON = "ON",
    TOOLTIP_OFF = "OFF",
    TOOLTIP_ACTIVATE = "Activate",
    TOOLTIP_DEACTIVATE = "Deactivate",
    TOOLTIP_CHANGE_LANG = "Change language",
    TOOLTIP_SCAN_QUESTS = "Scan quests",
    TOOLTIP_CLEAR_CACHE = "Clear cache",
    TOOLTIP_STATUS = "Status",
    LANG_SET = "Language set to",
    BUTTON_EXISTS = "Button already exists",
    BUTTON_CREATED = "Button created",
    SCAN_START = "Scanning quest log...",
    SCAN_END = "Scan complete",
    LANG_LIST = "Available languages:",
    LANG_USAGE = "Usage: /sqh lang [number]",
    CMD_HELP = "|cFF00CCFF=== Simple Quest Helper Commands ===|r",
    CMD_ON = "|cFF00FF00/sqh on|r - Enable announcements",
    CMD_OFF = "|cFFFF0000/sqh off|r - Disable announcements",
    CMD_LANG = "|cFFFFFF00/sqh lang|r - Change language",
    CMD_BUTTON = "|cFF00FFFF/sqh button|r - Recreate button",
    CMD_SCAN = "|cFFFF9900/sqh scan|r - Scan quests",
    CMD_AUTO_ACCEPT = "|cFF00FF00/sqh autoaccept|r - Toggle auto-accept",
    CMD_AUTO_COMPLETE = "|cFF00FF00/sqh autocomplete|r - Toggle auto-complete",
    CMD_HELP_TEXT = "|cFFCC00CC/sqh help|r - Show this help",
    UNKNOWN_CMD = "Unknown command. Type |cFF00CCFF/sqh help|r",
    LOADED = "|cFF00CCFFSimple Quest Helper v1.2|r loaded",
    TYPE_HELP = "Type |cFF00CCFF/sqh help|r for commands",
    CACHE_CLEARED = "Quest cache cleared",
    CACHE_CLEANED = "Cache cleaned"
}
