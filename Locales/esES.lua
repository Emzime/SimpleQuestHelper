-- ===================================================
-- SimpleQuestHelper - Locales/esES.lua
-- Localización española
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestHelper then SimpleQuestHelper = {} end
if not SimpleQuestHelper.Locales then SimpleQuestHelper.Locales = {} end

SimpleQuestHelper.Locales["esES"] = {
    PREFIX = "|cFF00CCFF[SQH]|r",
    COMPLETED = "¡Misión completada!",
    ENABLED = "Activado",
    DISABLED = "Desactivado",
    AUTO_ACCEPT_ON = "Auto-aceptar activado",
    AUTO_ACCEPT_OFF = "Auto-aceptar desactivado",
    AUTO_COMPLETE_ON = "Auto-completar activado",
    AUTO_COMPLETE_OFF = "Auto-completar desactivado",
    HELP = "Uso: /sqh on|off",
    TOOLTIP_TITLE = "Simple Quest Helper",
    TOOLTIP_LEFT_CLICK = "Clic izquierdo: Activar/desactivar anuncios",
    TOOLTIP_LEFT_SHIFT = "Shift+Clic izquierdo: Cambiar idioma",
    TOOLTIP_LEFT_ALT = "Alt+Clic izquierdo: Escanear misiones",
    TOOLTIP_RIGHT_CLICK = "Clic derecho: Activar/desactivar auto-aceptar",
    TOOLTIP_RIGHT_SHIFT = "Shift+Clic derecho: Activar/desactivar auto-completar",
    TOOLTIP_RIGHT_ALT = "Alt+Clic derecho: Limpiar caché",
    TOOLTIP_STATUS_ANNOUNCE = "Anuncios",
    TOOLTIP_STATUS_AUTOACCEPT = "Auto-aceptar",
    TOOLTIP_STATUS_AUTOCOMPLETE = "Auto-completar",
    TOOLTIP_ON = "ON",
    TOOLTIP_OFF = "OFF",
    TOOLTIP_ACTIVATE = "Activar",
    TOOLTIP_DEACTIVATE = "Desactivar",
    TOOLTIP_CHANGE_LANG = "Cambiar idioma",
    TOOLTIP_SCAN_QUESTS = "Escanear misiones",
    TOOLTIP_CLEAR_CACHE = "Limpiar caché",
    TOOLTIP_STATUS = "Estado",
    LANG_SET = "Idioma establecido a",
    BUTTON_EXISTS = "Botón ya existe",
    BUTTON_CREATED = "Botón creado",
    SCAN_START = "Escaneando registro de misiones...",
    SCAN_END = "Escaneo completado",
    LANG_LIST = "Idiomas disponibles:",
    LANG_USAGE = "Uso: /sqh lang [número]",
    CMD_HELP = "|cFF00CCFF=== Comandos Simple Quest Helper ===|r",
    CMD_ON = "|cFF00FF00/sqh on|r - Activar anuncios",
    CMD_OFF = "|cFFFF0000/sqh off|r - Desactivar anuncios",
    CMD_LANG = "|cFFFFFF00/sqh lang|r - Cambiar idioma",
    CMD_BUTTON = "|cFF00FFFF/sqh button|r - Recrear botón",
    CMD_SCAN = "|cFFFF9900/sqh scan|r - Escanear misiones",
    CMD_AUTO_ACCEPT = "|cFF00FF00/sqh autoaccept|r - Activar/desactivar auto-aceptar",
    CMD_AUTO_COMPLETE = "|cFF00FF00/sqh autocomplete|r - Activar/desactivar auto-completar",
    CMD_HELP_TEXT = "|cFFCC00CC/sqh help|r - Mostrar esta ayuda",
    UNKNOWN_CMD = "Comando desconocido. Escribe |cFF00CCFF/sqh help|r",
    LOADED = "|cFF00CCFFSimple Quest Helper v1.2|r cargado",
    TYPE_HELP = "Escribe |cFF00CCFF/sqh help|r para comandos",
    CACHE_CLEARED = "Caché de misiones limpiado",
    CACHE_CLEANED = "Caché limpiado"
}
