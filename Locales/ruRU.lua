-- ===================================================
-- SimpleQuestHelper - Locales/ruRU.lua
-- Русская локализация
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestHelper then SimpleQuestHelper = {} end
if not SimpleQuestHelper.Locales then SimpleQuestHelper.Locales = {} end

SimpleQuestHelper.Locales["ruRU"] = {
    PREFIX = "|cFF00CCFF[SQH]|r",
    COMPLETED = "Задание выполнено!",
    ENABLED = "Включено",
    DISABLED = "Отключено",
    AUTO_ACCEPT_ON = "Авто-принятие включено",
    AUTO_ACCEPT_OFF = "Авто-принятие отключено",
    AUTO_COMPLETE_ON = "Авто-завершение включено",
    AUTO_COMPLETE_OFF = "Авто-завершение отключено",
    HELP = "Использование: /sqh on|off",
    TOOLTIP_TITLE = "Simple Quest Helper",
    TOOLTIP_LEFT_CLICK = "Левый клик: Вкл/выкл объявления",
    TOOLTIP_LEFT_SHIFT = "Shift+Левый клик: Сменить язык",
    TOOLTIP_LEFT_ALT = "Alt+Левый клик: Сканировать задания",
    TOOLTIP_RIGHT_CLICK = "Правый клик: Вкл/выкл авто-принятие",
    TOOLTIP_RIGHT_SHIFT = "Shift+Правый клик: Вкл/выкл авто-завершение",
    TOOLTIP_RIGHT_ALT = "Alt+Правый клик: Очистить кэш",
    TOOLTIP_STATUS_ANNOUNCE = "Объявления",
    TOOLTIP_STATUS_AUTOACCEPT = "Авто-принятие",
    TOOLTIP_STATUS_AUTOCOMPLETE = "Авто-завершение",
    TOOLTIP_ON = "ВКЛ",
    TOOLTIP_OFF = "ВЫКЛ",
    TOOLTIP_ACTIVATE = "Активировать",
    TOOLTIP_DEACTIVATE = "Деактивировать",
    TOOLTIP_CHANGE_LANG = "Сменить язык",
    TOOLTIP_SCAN_QUESTS = "Сканировать задания",
    TOOLTIP_CLEAR_CACHE = "Очистить кэш",
    TOOLTIP_STATUS = "Статус",
    LANG_SET = "Язык установлен на",
    BUTTON_EXISTS = "Кнопка уже существует",
    BUTTON_CREATED = "Кнопка создана",
    SCAN_START = "Сканирование журнала заданий...",
    SCAN_END = "Сканирование завершено",
    LANG_LIST = "Доступные языки:",
    LANG_USAGE = "Использование: /sqh lang [номер]",
    CMD_HELP = "|cFF00CCFF=== Команды Simple Quest Helper ===|r",
    CMD_ON = "|cFF00FF00/sqh on|r - Включить объявления",
    CMD_OFF = "|cFFFF0000/sqh off|r - Отключить объявления",
    CMD_LANG = "|cFFFFFF00/sqh lang|r - Сменить язык",
    CMD_BUTTON = "|cFF00FFFF/sqh button|r - Восстановить кнопку",
    CMD_SCAN = "|cFFFF9900/sqh scan|r - Сканировать задания",
    CMD_AUTO_ACCEPT = "|cFF00FF00/sqh autoaccept|r - Вкл/выкл авто-принятие",
    CMD_AUTO_COMPLETE = "|cFF00FF00/sqh autocomplete|r - Вкл/выкл авто-завершение",
    CMD_HELP_TEXT = "|cFFCC00CC/sqh help|r - Показать эту справку",
    UNKNOWN_CMD = "Неизвестная команда. Введите |cFF00CCFF/sqh help|r",
    LOADED = "|cFF00CCFFSimple Quest Helper v1.2|r загружен",
    TYPE_HELP = "Введите |cFF00CCFF/sqh help|r для команд",
    CACHE_CLEARED = "Кэш заданий очищен",
    CACHE_CLEANED = "Кэш очищен"
}
