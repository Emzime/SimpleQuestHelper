-- ===================================================
-- SimpleQuestAnnouncer - Locales/itIT.lua
-- Localisation italiana
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestAnnouncer then SimpleQuestAnnouncer = {} end
if not SimpleQuestAnnouncer.Locales then SimpleQuestAnnouncer.Locales = {} end

SimpleQuestAnnouncer.Locales["itIT"] = {
    PREFIX = "|cFF00CCFF[SQA]|r",
    COMPLETED = "Missione completata!",
    ENABLED = "Abilitato",
    DISABLED = "Disabilitato",
    HELP = "Uso: /sqa on|off",
    TOOLTIP_LEFT = "Clic sinistro: Attiva/Disattiva",
    TOOLTIP_RIGHT = "Clic destro: Menu lingua",
    TOOLTIP_STATUS = "Stato",
    LANG_SET = "Lingua impostata a",
    BUTTON_EXISTS = "Il pulsante esiste già",
    BUTTON_CREATED = "Pulsante creato",
    SCAN_START = "Scansione registro missioni...",
    SCAN_END = "Scansione completata",
    LANG_LIST = "Lingue disponibili:",
    LANG_USAGE = "Uso: /sqa lang [numero]",
    CMD_HELP = "|cFF00CCFF=== Comandi Simple Quest Announcer ===|r",
    CMD_ON = "|cFF00FF00/sqa on|r - Abilita annunci",
    CMD_OFF = "|cFFFF0000/sqa off|r - Disabilita annunci",
    CMD_LANG = "|cFFFFFF00/sqa lang|r - Cambia lingua",
    CMD_BUTTON = "|cFF00FFFF/sqa button|r - Ricrea pulsante",
    CMD_SCAN = "|cFFFF9900/sqa scan|r - Scansiona missioni",
    CMD_HELP_TEXT = "|cFFCC00CC/sqa help|r - Mostra questo aiuto",
    UNKNOWN_CMD = "Comando sconosciuto. Digita |cFF00CCFF/sqa help|r",
    LOADED = "|cFF00CCFFSimple Quest Announcer v1.0|r caricato",
    TYPE_HELP = "Digita |cFF00CCFF/sqa help|r per i comandi",
    CACHE_CLEARED = "Cache missioni cancellato",
    CACHE_CLEANED = "Cache pulito",
    SILENT_MODE = "Modalità silenziosa per",
    ANNOUNCEMENTS_ENABLED = "Annunci attivati",
    NOT_INITIALIZED = "Non ancora inizializzato",
    SECONDS = "secondi"
}
