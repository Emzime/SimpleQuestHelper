-- ===================================================
-- SimpleQuestAnnouncer - Locales/ptBR.lua
-- Localização portuguesa (Brasil)
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestAnnouncer then SimpleQuestAnnouncer = {} end
if not SimpleQuestAnnouncer.Locales then SimpleQuestAnnouncer.Locales = {} end

SimpleQuestAnnouncer.Locales["ptBR"] = {
    PREFIX = "|cFF00CCFF[SQA]|r",
    COMPLETED = "Missão completada!",
    ENABLED = "Ativado",
    DISABLED = "Desativado",
    HELP = "Uso: /sqa on|off",
    TOOLTIP_LEFT = "Clique esquerdo: Ativar/Desativar",
    TOOLTIP_RIGHT = "Clique direito: Menu de idiomas",
    TOOLTIP_STATUS = "Status",
    LANG_SET = "Idioma definido para",
    BUTTON_EXISTS = "Botão já existe",
    BUTTON_CREATED = "Botão criado",
    SCAN_START = "Escaneando registro de missões...",
    SCAN_END = "Escaneamento completo",
    LANG_LIST = "Idiomas disponíveis:",
    LANG_USAGE = "Uso: /sqa lang [número]",
    CMD_HELP = "|cFF00CCFF=== Comandos Simple Quest Announcer ===|r",
    CMD_ON = "|cFF00FF00/sqa on|r - Ativar anúncios",
    CMD_OFF = "|cFFFF0000/sqa off|r - Desativar anúncios",
    CMD_LANG = "|cFFFFFF00/sqa lang|r - Alterar idioma",
    CMD_BUTTON = "|cFF00FFFF/sqa button|r - Recriar botão",
    CMD_SCAN = "|cFFFF9900/sqa scan|r - Escanear missões",
    CMD_HELP_TEXT = "|cFFCC00CC/sqa help|r - Mostrar esta ajuda",
    UNKNOWN_CMD = "Comando desconhecido. Digite |cFF00CCFF/sqa help|r",
    LOADED = "|cFF00CCFFSimple Quest Announcer v1.0|r carregado",
    TYPE_HELP = "Digite |cFF00CCFF/sqa help|r para comandos",
    CACHE_CLEARED = "Cache de missões limpo",
    CACHE_CLEANED = "Cache limpo",
    SILENT_MODE = "Modo silencioso por",
    ANNOUNCEMENTS_ENABLED = "Anúncios ativados",
    NOT_INITIALIZED = "Não inicializado ainda",
    SECONDS = "segundos"
}
