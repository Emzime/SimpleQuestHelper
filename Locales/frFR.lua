-- ===================================================
-- SimpleQuestAnnouncer - Locales/frFR.lua
-- Localisation française
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestAnnouncer then SimpleQuestAnnouncer = {} end
if not SimpleQuestAnnouncer.Locales then SimpleQuestAnnouncer.Locales = {} end

SimpleQuestAnnouncer.Locales["frFR"] = {
    PREFIX = "|cFF00CCFF[SQA]|r",
    COMPLETED = "Quête terminée !",
    ENABLED = "Activé",
    DISABLED = "Désactivé",
    HELP = "Usage: /sqa on|off",
    TOOLTIP_LEFT = "Clic gauche: Activer/Désactiver",
    TOOLTIP_RIGHT = "Clic droit: Menu des langues",
    TOOLTIP_STATUS = "Statut",
    LANG_SET = "Langue définie sur",
    BUTTON_EXISTS = "Bouton déjà créé",
    BUTTON_CREATED = "Bouton créé",
    SCAN_START = "Scan du journal de quêtes...",
    SCAN_END = "Scan terminé",
    LANG_LIST = "Langues disponibles:",
    LANG_USAGE = "Usage: /sqa lang [numéro]",
    CMD_HELP = "|cFF00CCFF=== Commandes Simple Quest Announcer ===|r",
    CMD_ON = "|cFF00FF00/sqa on|r - Activer les annonces",
    CMD_OFF = "|cFFFF0000/sqa off|r - Désactiver les annonces",
    CMD_LANG = "|cFFFFFF00/sqa lang|r - Changer la langue",
    CMD_BUTTON = "|cFF00FFFF/sqa button|r - Recréer le bouton",
    CMD_SCAN = "|cFFFF9900/sqa scan|r - Scanner les quêtes",
    CMD_HELP_TEXT = "|cFFCC00CC/sqa help|r - Afficher cette aide",
    UNKNOWN_CMD = "Commande inconnue. Tapez |cFF00CCFF/sqa help|r",
    LOADED = "|cFF00CCFFSimple Quest Announcer v1.0|r chargé",
    TYPE_HELP = "Tapez |cFF00CCFF/sqa help|r pour les commandes",
    CACHE_CLEARED = "Cache des quêtes effacé",
    CACHE_CLEANED = "Cache nettoyé",
	SILENT_MODE = "Mode silencieux pour",
    ANNOUNCEMENTS_ENABLED = "Annonces activées",
    NOT_INITIALIZED = "Non initialisé",
    SECONDS = "secondes"
}
