-- ===================================================
-- SimpleQuestAnnouncer - Locales/esES.lua
-- Localisation espagnole (España)
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestAnnouncer then SimpleQuestAnnouncer = {} end
if not SimpleQuestAnnouncer.Locales then SimpleQuestAnnouncer.Locales = {} end

SimpleQuestAnnouncer.Locales["esES"] = {
    PREFIX = "|cFF00CCFF[SQA]|r",
    COMPLETED = "¡Misión completada!",
    ENABLED = "Activado",
    DISABLED = "Desactivado",
    HELP = "Uso: /sqa on|off",
    TOOLTIP_LEFT = "Clic izquierdo: Activar/Desactivar",
    TOOLTIP_RIGHT = "Clic derecho: Menú de idiomas",
    TOOLTIP_STATUS = "Estado",
    LANG_SET = "Idioma establecido a",
    BUTTON_EXISTS = "El botón ya existe",
    BUTTON_CREATED = "Botón creado",
    SCAN_START = "Escaneando registro de misiones...",
    SCAN_END = "Escaneo completado",
    LANG_LIST = "Idiomas disponibles:",
    LANG_USAGE = "Uso: /sqa lang [número]",
    CMD_HELP = "|cFF00CCFF=== Comandos Simple Quest Announcer ===|r",
    CMD_ON = "|cFF00FF00/sqa on|r - Activar anuncios",
    CMD_OFF = "|cFFFF0000/sqa off|r - Desactivar anuncios",
    CMD_LANG = "|cFFFFFF00/sqa lang|r - Cambiar idioma",
    CMD_BUTTON = "|cFF00FFFF/sqa button|r - Recrear botón",
    CMD_SCAN = "|cFFFF9900/sqa scan|r - Escanear misiones",
    CMD_HELP_TEXT = "|cFFCC00CC/sqa help|r - Mostrar esta ayuda",
    UNKNOWN_CMD = "Comando desconocido. Escribe |cFF00CCFF/sqa help|r",
    LOADED = "|cFF00CCFFSimple Quest Announcer v1.0|r cargado",
    TYPE_HELP = "Escribe |cFF00CCFF/sqa help|r para ver los comandos",
    CACHE_CLEARED = "Caché de misiones borrado",
    CACHE_CLEANED = "Caché limpiado",
    SILENT_MODE = "Modo silencioso durante",
    ANNOUNCEMENTS_ENABLED = "Anuncios activados",
    NOT_INITIALIZED = "No inicializado aún",
    SECONDS = "segundos"
}
