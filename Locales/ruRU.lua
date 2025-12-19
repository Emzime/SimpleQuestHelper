-- ===================================================
-- SimpleQuestAnnouncer - Locales/ruRU.lua
-- Русская локализация
-- Compatible WoW 1.12 (LUA 5.0)
-- ===================================================

if not SimpleQuestAnnouncer then SimpleQuestAnnouncer = {} end
if not SimpleQuestAnnouncer.Locales then SimpleQuestAnnouncer.Locales = {} end

SimpleQuestAnnouncer.Locales["ruRU"] = {
    PREFIX = "|cFF00CCFF[SQA]|r",
    COMPLETED = "Задание выполнено!",
    ENABLED = "Включено",
    DISABLED = "Выключено",
    HELP = "Использование: /sqa on|off",
    TOOLTIP_LEFT = "Левый клик: Включить/Выключить",
    TOOLTIP_RIGHT = "Правый клик: Меню языка",
    TOOLTIP_STATUS = "Статус",
    LANG_SET = "Язык установлен на",
    BUTTON_EXISTS = "Кнопка уже существует",
    BUTTON_CREATED = "Кнопка создана",
    SCAN_START = "Сканирование журнала заданий...",
    SCAN_END = "Сканирование завершено",
    LANG_LIST = "Доступные языки:",
    LANG_USAGE = "Использование: /sqa lang [номер]",
    CMD_HELP = "|cFF00CCFF=== Команды Simple Quest Announcer ===|r",
    CMD_ON = "|cFF00FF00/sqa on|r - Включить уведомления",
    CMD_OFF = "|cFFFF0000/sqa off|r - Выключить уведомления",
    CMD_LANG = "|cFFFFFF00/sqa lang|r - Изменить язык",
    CMD_BUTTON = "|cFF00FFFF/sqa button|r - Воссоздать кнопку",
    CMD_SCAN = "|cFFFF9900/sqa scan|r - Сканировать задания",
    CMD_HELP_TEXT = "|cFFCC00CC/sqa help|r - Показать эту справку",
    UNKNOWN_CMD = "Неизвестная команда. Введите |cFF00CCFF/sqa help|r",
    LOADED = "|cFF00CCFFSimple Quest Announcer v1.0|r загружен",
    TYPE_HELP = "Введите |cFF00CCFF/sqa help|r для команд",
    CACHE_CLEARED = "Кэш заданий очищен",
    CACHE_CLEANED = "Кэш очищен",
    SILENT_MODE = "Тихий режим на",
    ANNOUNCEMENTS_ENABLED = "Уведомления включены",
    NOT_INITIALIZED = "Еще не инициализирован",
    SECONDS = "секунд"
}
