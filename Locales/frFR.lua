-- ===================================================
-- SimpleQuestHelper - Locales/frFR.lua
-- Localisation française
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestHelper then SimpleQuestHelper = {} end
if not SimpleQuestHelper.Locales then SimpleQuestHelper.Locales = {} end

SimpleQuestHelper.Locales["frFR"] = {
    PREFIX = "|cFF00CCFF[SQH]|r",
    COMPLETED = "Quête terminée !",
    ENABLED = "Activé",
    DISABLED = "Désactivé",
    AUTO_ACCEPT_ON = "Auto-acceptation activée",
    AUTO_ACCEPT_OFF = "Auto-acceptation désactivée",
    AUTO_COMPLETE_ON = "Auto-complétion activée",
    AUTO_COMPLETE_OFF = "Auto-complétion désactivée",
    HELP = "Utilisation : /sqh on|off",
    TOOLTIP_TITLE = "Simple Quest Helper",
    TOOLTIP_LEFT_CLICK = "Clic gauche : Activer/désactiver annonces",
    TOOLTIP_LEFT_SHIFT = "Shift+Clic gauche : Changer langue",
    TOOLTIP_LEFT_ALT = "Alt+Clic gauche : Scanner quêtes",
    TOOLTIP_RIGHT_CLICK = "Clic droit : Activer/désactiver auto-acceptation",
    TOOLTIP_RIGHT_SHIFT = "Shift+Clic droit : Activer/désactiver auto-complétion",
    TOOLTIP_RIGHT_ALT = "Alt+Clic droit : Vider cache",
    TOOLTIP_STATUS_ANNOUNCE = "Annonces",
    TOOLTIP_STATUS_AUTOACCEPT = "Auto-acceptation",
    TOOLTIP_STATUS_AUTOCOMPLETE = "Auto-complétion",
    TOOLTIP_ON = "ON",
    TOOLTIP_OFF = "OFF",
    TOOLTIP_ACTIVATE = "Activer",
    TOOLTIP_DEACTIVATE = "Désactiver",
    TOOLTIP_CHANGE_LANG = "Changer langue",
    TOOLTIP_SCAN_QUESTS = "Scanner quêtes",
    TOOLTIP_CLEAR_CACHE = "Vider cache",
    TOOLTIP_STATUS = "Statut",
    LANG_SET = "Langue définie sur",
    BUTTON_EXISTS = "Bouton déjà existant",
    BUTTON_CREATED = "Bouton créé",
    SCAN_START = "Scan du journal de quêtes...",
    SCAN_END = "Scan terminé",
    LANG_LIST = "Langues disponibles :",
    LANG_USAGE = "Utilisation : /sqh lang [numéro]",
    CMD_HELP = "|cFF00CCFF=== Commandes Simple Quest Helper ===|r",
    CMD_ON = "|cFF00FF00/sqh on|r - Activer annonces",
    CMD_OFF = "|cFFFF0000/sqh off|r - Désactiver annonces",
    CMD_LANG = "|cFFFFFF00/sqh lang|r - Changer langue",
    CMD_BUTTON = "|cFF00FFFF/sqh button|r - Recréer bouton",
    CMD_SCAN = "|cFFFF9900/sqh scan|r - Scanner quêtes",
    CMD_AUTO_ACCEPT = "|cFF00FF00/sqh autoaccept|r - Activer/désactiver auto-acceptation",
    CMD_AUTO_COMPLETE = "|cFF00FF00/sqh autocomplete|r - Activer/désactiver auto-complétion",
    CMD_HELP_TEXT = "|cFFCC00CC/sqh help|r - Afficher cette aide",
    UNKNOWN_CMD = "Commande inconnue. Tapez |cFF00CCFF/sqh help|r",
    LOADED = "|cFF00CCFFSimple Quest Helper v1.2|r chargé",
    TYPE_HELP = "Tapez |cFF00CCFF/sqh help|r pour les commandes",
    CACHE_CLEARED = "Cache de quêtes vidé",
    CACHE_CLEANED = "Cache nettoyé"
}
