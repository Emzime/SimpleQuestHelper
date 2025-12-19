-- SimpleQuestAnnouncer pour WoW 1.12 (Lua 5.0)
-- Version optimisée anti-crash

-- Table principale
SimpleQuestAnnouncer = {}
local SQA = SimpleQuestAnnouncer

-------------------------------------------------
-- Configuration sauvegardée - CORRIGÉE
-------------------------------------------------

SQA_Config = SQA_Config or {
    enabled = true,
    language = "AUTO"
}

-- S'assurer que lastObjectives existe (pour compatibilité avec anciennes sauvegardes)
if not SQA_Config.lastObjectives then
    SQA_Config.lastObjectives = {}
end

SQA.enabled = SQA_Config.enabled
SQA.language = SQA_Config.language
SQA.lastObjectives = SQA_Config.lastObjectives
SQA.initialized = false
SQA.inCombat = false
SQA.isScanning = false

-- Temps de chargement pour éviter les annonces au démarrage
local loadTime = 0
local startupSilence = 15  -- Secondes de silence après /reload

-- NOUVEAU : Throttling des scans
local lastScanTime = 0
local minScanInterval = 0.5  -- Minimum 0.5 secondes entre chaque scan EN COMBAT
local minScanIntervalOutOfCombat = 0.2  -- Plus rapide hors combat
local pendingScan = false

-------------------------------------------------
-- Localisation de base (ANGLAIS par défaut)
-------------------------------------------------

SQA.L = {
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
    LOADED = "|cFF00CCFFSimple Quest Announcer v1.1|r loaded",
    TYPE_HELP = "Type |cFF00CCFF/sqa help|r for commands",
    BUTTON_CREATED = "Button created",
    CACHE_CLEARED = "Quest cache cleared",
    CACHE_CLEANED = "Cache cleaned"
}

-- Table des locales disponibles
SQA.Locales = {
    ["enUS"] = SQA.L  -- anglais par défaut
}

-------------------------------------------------
-- Fonction pour charger les locales externes
-------------------------------------------------

function SQA:LoadExternalLocales()
    -- Vérifier si la table globale existe
    if not SimpleQuestAnnouncer.Locales then
        return
    end

    -- Copier toutes les locales depuis la table globale
    for lang, localeTable in pairs(SimpleQuestAnnouncer.Locales) do
        if type(localeTable) == "table" then
            SQA.Locales[lang] = localeTable
        end
    end
end

-------------------------------------------------
-- Fonction pour définir la langue
-------------------------------------------------

function SQA:SetLanguage(lang)
    -- Charger toutes les locales d'abord
    SQA:LoadExternalLocales()

    -- Déterminer la langue cible
    local targetLang = lang

    if lang == "AUTO" then
        local clientLang = GetLocale()
        targetLang = clientLang

        -- Si la langue du client n'est pas disponible, utiliser enUS
        if not SQA.Locales[targetLang] then
            targetLang = "enUS"
        end
    end

    -- Vérifier si la langue cible existe
    if not SQA.Locales[targetLang] then
        targetLang = "enUS"
    end

    -- Créer une nouvelle table pour SQA.L
    local newLocale = {}
    for key, value in pairs(SQA.Locales[targetLang]) do
        newLocale[key] = value
    end

    -- S'assurer d'avoir toutes les clés
    for key, value in pairs(SQA.Locales["enUS"]) do
        if not newLocale[key] then
            newLocale[key] = value
        end
    end

    -- Remplacer SQA.L
    SQA.L = newLocale

    -- Sauvegarder la configuration
    SQA.language = lang
    SQA_Config.language = lang
    SQA_Config.enabled = SQA.enabled

    -- Message de confirmation
    local langNames = {
        ["AUTO"] = "|cFF00CCFFAuto (Client)|r",
        ["enUS"] = "|cFFFF9900English|r",
        ["frFR"] = "|cFF00FF00Français|r",
        ["deDE"] = "|cFFFF0000Deutsch|r",
        ["esES"] = "|cFFFFFF00Español|r",
        ["itIT"] = "|cFF00FFFFItaliano|r",
        ["ptBR"] = "|cFFFF00FFPortuguês|r",
        ["ruRU"] = "|cFFCC0000Russian|r"
    }

    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.LANG_SET .. " " .. (langNames[lang] or lang))

    -- Mettre à jour le bouton
    if SQAMinimapButton then
        if SQA.enabled then
            SQAMinimapButton.icon:SetVertexColor(1, 1, 1)
        else
            SQAMinimapButton.icon:SetVertexColor(0.5, 0.5, 0.5)
        end
    end
end

-------------------------------------------------
-- Fonction d'annonce - SILENCIEUSE au démarrage
-------------------------------------------------

local function SendAnnouncement(msg, isComplete)
    -- NE PAS annoncer pendant les premières secondes après /reload
    if GetTime() - loadTime < startupSilence then
        return
    end

    if not SQA.enabled then return end

    if GetNumPartyMembers() > 0 then
        SendChatMessage(SQA.L.PREFIX .. " " .. msg, "PARTY")
    else
        -- Envoyer dans l'onglet de chat actif
        local targetFrame = SELECTED_CHAT_FRAME

        if targetFrame and type(targetFrame.AddMessage) == "function" then
            targetFrame:AddMessage(SQA.L.PREFIX .. " " .. msg)
        else
            DEFAULT_CHAT_FRAME:AddMessage(SQA.L.PREFIX .. " " .. msg)
        end
    end

    if isComplete then
        UIErrorsFrame:AddMessage(SQA.L.PREFIX .. " " .. SQA.L.COMPLETED, 0, 1, 0, 1, 0.5)
    end
end

-------------------------------------------------
-- Fonction pour extraire les nombres d'un texte - CORRIGÉE pour Lua 5.0
-------------------------------------------------

local function ExtractNumbers(text)
    if not text then return nil end

    -- Chercher le format "X/Y" (ex: "10/10") avec string.find pour Lua 5.0
    local startPos, endPos, currentStr, totalStr = string.find(text, "(%d+)/(%d+)")
    if startPos then
        local current = tonumber(currentStr)
        local total = tonumber(totalStr)
        if current and total then
            return current, total
        end
    end

    -- Chercher le format "X de Y" (français)
    startPos, endPos, currentStr, totalStr = string.find(text, "(%d+) de (%d+)")
    if startPos then
        local current = tonumber(currentStr)
        local total = tonumber(totalStr)
        if current and total then
            return current, total
        end
    end

    -- Chercher le format "X of Y" (anglais)
    startPos, endPos, currentStr, totalStr = string.find(text, "(%d+) of (%d+)")
    if startPos then
        local current = tonumber(currentStr)
        local total = tonumber(totalStr)
        if current and total then
            return current, total
        end
    end

    return nil, nil
end

-------------------------------------------------
-- Fonction pour extraire le nom de quête d'une clé
-------------------------------------------------

local function ExtractQuestNameFromKey(key)
    if not key then return nil end

    -- Chercher le pattern "nom_de_quete:quelquechose"
    local colonPos = string.find(key, ":")
    if colonPos then
        return string.sub(key, 1, colonPos - 1)
    end

    return nil
end

-------------------------------------------------
-- Scanner les quêtes - VERSION OPTIMISÉE
-------------------------------------------------

local function ScanQuestLog()
    -- Éviter les scans en cascade
    if SQA.isScanning then return end

    -- NOUVEAU : Throttling adaptatif selon le combat
    local currentTime = GetTime()
    local interval = SQA.inCombat and minScanInterval or minScanIntervalOutOfCombat

    if currentTime - lastScanTime < interval then
        -- Marquer qu'un scan est en attente
        pendingScan = true
        return
    end

    SQA.isScanning = true
    lastScanTime = currentTime
    pendingScan = false

    -- Ne pas scanner avant l'initialisation
    if not SQA.initialized or not SQA.enabled then
        SQA.isScanning = false
        return
    end

    -- Vérifications de sécurité
    if not GetNumQuestLogEntries or type(GetNumQuestLogEntries) ~= "function" then
        SQA.isScanning = false
        return
    end

    local numEntries = GetNumQuestLogEntries()
    if not numEntries or numEntries <= 0 then
        SQA.isScanning = false
        return
    end

    -- Liste des quêtes actuellement dans le journal
    local currentQuests = {}

    -- Scanner toutes les quêtes
    for i = 1, numEntries do
        local title, _, _, isHeader, _, isComplete = GetQuestLogTitle(i)
        if title and title ~= "" and not isHeader then
            -- Marquer cette quête comme présente
            currentQuests[title] = true

            -- Sélectionner la quête
            SelectQuestLogEntry(i)

            -- Vérifier les objectifs
            local numObjectives = GetNumQuestLeaderBoards()
            if numObjectives and numObjectives > 0 then
                for j = 1, numObjectives do
                    local text, _, finished = GetQuestLogLeaderBoard(j)
                    if text and text ~= "" then
                        local key = title .. ":" .. j
                        local oldValue = SQA.lastObjectives[key]

                        -- Extraire les nombres pour la comparaison
                        local current, total = ExtractNumbers(text)

                        if current and total then
                            -- Sauvegarder la valeur numérique actuelle
                            local numericValue = current .. "/" .. total

                            -- Annoncer seulement si la valeur a CHANGÉ et n'est PAS 0/quelquechose
                            if oldValue and oldValue ~= numericValue then
                                -- Sauvegarder la nouvelle valeur
                                SQA.lastObjectives[key] = numericValue
                                SQA_Config.lastObjectives[key] = numericValue

                                -- Ne pas annoncer si c'est 0/X (première fois qu'on voit la quête)
                                if current > 0 then
                                    SendAnnouncement("|cFFFFFF00" .. title .. "|r - " .. text)
                                end
                            elseif not oldValue then
                                -- Première fois qu'on voit cet objectif, sauvegarder mais ne pas annoncer
                                SQA.lastObjectives[key] = numericValue
                                SQA_Config.lastObjectives[key] = numericValue
                            end
                        end
                    end
                end
            end

            -- Vérifier si la quête est terminée
            if isComplete == 1 then
                local doneKey = title .. ":done"
                if not SQA.lastObjectives[doneKey] then
                    -- Marquer comme terminée
                    SQA.lastObjectives[doneKey] = true
                    SQA_Config.lastObjectives[doneKey] = true

                    -- Annoncer la quête terminée
                    SendAnnouncement("|cFF00FF00" .. title .. " " .. SQA.L.COMPLETED .. "|r", true)
                end
            end
        end
    end

    -- Nettoyer le cache des quêtes qui ne sont plus dans le journal
    for key, _ in pairs(SQA.lastObjectives) do
        local questTitle = ExtractQuestNameFromKey(key)
        if questTitle and not currentQuests[questTitle] then
            -- Cette quête n'est plus dans le journal, la supprimer du cache
            SQA.lastObjectives[key] = nil
            SQA_Config.lastObjectives[key] = nil
        end
    end

    SQA.isScanning = false
end

-------------------------------------------------
-- Scanner avec THROTTLING
-------------------------------------------------

local function RequestScan()
    if SQA.enabled and SQA.initialized then
        local currentTime = GetTime()
        local interval = SQA.inCombat and minScanInterval or minScanIntervalOutOfCombat

        -- Si assez de temps s'est écoulé, scanner immédiatement
        if currentTime - lastScanTime >= interval then
            ScanQuestLog()
        else
            -- Sinon, marquer qu'un scan est en attente
            pendingScan = true
        end
    end
end

-------------------------------------------------
-- Menu déroulant des langues
-------------------------------------------------

local function ShowLanguageMenu()
    -- Vérifier si le menu existe déjà, sinon le créer
    if not _G["SQALanguageMenu"] then
        CreateFrame("Frame", "SQALanguageMenu", UIParent, "UIDropDownMenuTemplate")
    end

    -- Fermer tout menu existant
    CloseDropDownMenus()

    -- Liste des langues
    local languageList = {
        {text = "|cFF00CCFFAuto (Client)|r", value = "AUTO"},
        {text = "|cFFFF9900English|r", value = "enUS"},
        {text = "|cFF00FF00Français|r", value = "frFR"},
        {text = "|cFFFF0000Deutsch|r", value = "deDE"},
        {text = "|cFFFFFF00Español|r", value = "esES"},
        {text = "|cFF00FFFFItaliano|r", value = "itIT"},
        {text = "|cFFFF00FFPortuguês|r", value = "ptBR"},
        {text = "|cFFCC0000Russian|r", value = "ruRU"}
    }

    -- Initialiser le menu
    UIDropDownMenu_Initialize(_G["SQALanguageMenu"], function()
        for i = 1, 8 do
            local lang = languageList[i]
            local info = UIDropDownMenu_CreateInfo()
            info.text = lang.text
            info.value = lang.value
            info.func = function()
                SQA:SetLanguage(lang.value)
            end
            info.checked = (SQA.language == lang.value)
            info.notCheckable = false
            UIDropDownMenu_AddButton(info)
        end
    end)

    -- Afficher le menu
    ToggleDropDownMenu(1, nil, _G["SQALanguageMenu"], "cursor", 0, 0)
end

-- ===================================================
-- INITIALISATION DU BOUTON MINIMAP POUR SQA
-- Version inspirée de EmzTools
-- ===================================================

function SQA:InitializeButton()
    if not Minimap then return false end

    if SQAMinimapButton then
        SQAMinimapButton:Show()
        return true
    end

    self:CreateButton()
    return true
end

-------------------------------------------------
-- Fonction pour créer le bouton minimap
-- Version corrigée pour correspondre à EmzTools
-------------------------------------------------

function SQA:CreateButton()
    -- D'abord détruire l'ancien bouton s'il existe
    if SQAMinimapButton then
        SQAMinimapButton:Hide()
        SQAMinimapButton = nil
    end

    if self.minimapButton then return end

    -- Création de la frame
    local button = CreateFrame("Button", "SQAMinimapButton", Minimap)
    button:SetWidth(40)
    button:SetHeight(40)
    button:SetFrameStrata("MEDIUM")

    -- IMPORTANT: Ne pas utiliser SetPoint fixe, laisser pfUI gérer la position
    -- Si pfUI n'est pas présent, utiliser une position par défaut
    if not (pfUI and pfUI.minimap) then
        button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 10, -75)
    end

    -- Cercle doré autour de l'image (TOUJOURS présent)
    button.goldCircle = button:CreateTexture(nil, "ARTWORK")
    button.goldCircle:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    button.goldCircle:SetWidth(32)
    button.goldCircle:SetHeight(32)
    button.goldCircle:SetPoint("CENTER", 0, -3)
    button.goldCircle:SetTexCoord(0, 0.6, 0, 0.6)

    -- Icône personnalisée
    button.icon = button:CreateTexture(nil, "BACKGROUND")
    button.icon:SetTexture("Interface\\AddOns\\SimpleQuestAnnouncer\\icon")
    button.icon:SetWidth(20)
    button.icon:SetHeight(20)
    button.icon:SetPoint("CENTER", 0, -4)
    button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

    -- Highlight au survol
    button.highlight = button:CreateTexture(nil, "HIGHLIGHT")
    button.highlight:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    button.highlight:SetWidth(32)
    button.highlight:SetHeight(32)
    button.highlight:SetPoint("CENTER", 0, -3)
    button.highlight:SetTexCoord(0, 0.6, 0, 0.6)
    button.highlight:SetBlendMode("ADD")

    -- ===================================================
    -- GESTION DU DRAG (identique à EmzTools)
    -- ===================================================

    button:SetScript("OnDragStart", function()
        this:StartMoving()
        this.isMoving = true
    end)

    button:SetScript("OnDragStop", function()
        this:StopMovingOrSizing()
        this.isMoving = false
    end)

    -- ===================================================
    -- COMPORTEMENT AU SURVOL ET CLIC
    -- ===================================================

    button:SetAlpha(0.9)

    button:SetScript("OnEnter", function()
        this:SetAlpha(1)
        GameTooltip:SetOwner(this, "ANCHOR_LEFT")
        GameTooltip:SetText("|cFF00CCFFSimple Quest Announcer|r")
        GameTooltip:AddLine(SQA.L.TOOLTIP_LEFT, 1, 1, 1)
        GameTooltip:AddLine(SQA.L.TOOLTIP_RIGHT, 1, 1, 1)
        GameTooltip:AddLine(SQA.L.TOOLTIP_STATUS .. ": " .. (SQA.enabled and "|cFF00FF00" .. SQA.L.ENABLED .. "|r" or "|cFFFF0000" .. SQA.L.DISABLED .. "|r"), 1, 1, 1)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function()
        this:SetAlpha(0.9)
        GameTooltip:Hide()
    end)

	button:SetScript("OnMouseUp", function()
        if arg1 == "RightButton" then
            ShowLanguageMenu()
        elseif arg1 == "LeftButton" then
            SQA.enabled = not SQA.enabled
            SQA_Config.enabled = SQA.enabled

            if SQA.enabled then
                this.icon:SetVertexColor(1, 1, 1)
                DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.ENABLED)
            else
                this.icon:SetVertexColor(0.5, 0.5, 0.5)
                DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.DISABLED)
            end
        end
    end)

    -- ===================================================
    -- VISIBILITÉ (simplifiée par rapport à EmzTools)
    -- ===================================================

    function button:HideButton()
        self:Hide()
    end

    function button:ShowButton()
        self:Show()
    end

    function button:Toggle()
        if self:IsVisible() then
            self:HideButton()
        else
            self:ShowButton()
        end
    end

    -- ===================================================
    -- AFFICHAGE INITIAL
    -- ===================================================

    button:Show()

    -- Enregistrer le bouton comme propriété de SQA
    self.minimapButton = button

    return button
end

-- ===================================================
-- Fonctions utilitaires supplémentaires
-- pour correspondre à l'API d'EmzTools
-- ===================================================

function SQA:Retry()
    if not self.minimapButton or not self.minimapButton:IsShown() then
        self:InitializeButton()
    end
end

function SQA:ForceCreate()
    if not self.minimapButton then
        self:CreateButton()
        self.minimapButton:Show()
    end
end

-------------------------------------------------
-- Commandes slash
-------------------------------------------------

SLASH_SIMPLEQUESTANNOUNCER1 = "/sqa"
SlashCmdList["SIMPLEQUESTANNOUNCER"] = function(msg)
    msg = string.lower(msg or "")

    if msg == "on" then
        SQA.enabled = true
        SQA_Config.enabled = true
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.ENABLED)

        if SQAMinimapButton then
            SQAMinimapButton.icon:SetVertexColor(1, 1, 1)
        end

    elseif msg == "off" then
        SQA.enabled = false
        SQA_Config.enabled = false
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.DISABLED)

        if SQAMinimapButton then
            SQAMinimapButton.icon:SetVertexColor(0.5, 0.5, 0.5)
        end

    elseif string.sub(msg, 1, 4) == "lang" then
        local num = tonumber(string.sub(msg, 6))
        local langs = {
            {1, "|cFF00CCFFAuto (Client)|r", "AUTO"},
            {2, "|cFFFF9900English|r", "enUS"},
            {3, "|cFF00FF00Français|r", "frFR"},
            {4, "|cFFFF0000Deutsch|r", "deDE"},
            {5, "|cFFFFFF00Español|r", "esES"},
            {6, "|cFF00FFFFItaliano|r", "itIT"},
            {7, "|cFFFF00FFPortuguês|r", "ptBR"},
            {8, "|cFFCC0000Russian|r", "ruRU"}
        }

        if num and langs[num] then
            SQA:SetLanguage(langs[num][3])
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFF" .. SQA.L.LANG_LIST .. "|r")
            for i = 1, 8 do
                local lang = langs[i]
                DEFAULT_CHAT_FRAME:AddMessage(lang[1] .. ". " .. lang[2])
            end
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00" .. SQA.L.LANG_USAGE .. "|r")
        end

    elseif msg == "button" then
        if not SQAMinimapButton then
            SQA:CreateButton()
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.BUTTON_CREATED)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.BUTTON_EXISTS)
        end

    elseif msg == "scan" then
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.SCAN_START)
        if SQA.initialized then
            ScanQuestLog()
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.SCAN_END)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000SQA:|r Not initialized yet")
        end

    elseif msg == "clear" then
        SQA.lastObjectives = {}
        SQA_Config.lastObjectives = {}
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.CACHE_CLEARED)

    elseif msg == "help" or msg == "" or msg == "?" then
        DEFAULT_CHAT_FRAME:AddMessage(SQA.L.CMD_HELP)
        DEFAULT_CHAT_FRAME:AddMessage(SQA.L.CMD_ON)
        DEFAULT_CHAT_FRAME:AddMessage(SQA.L.CMD_OFF)
        DEFAULT_CHAT_FRAME:AddMessage(SQA.L.CMD_LANG)
        DEFAULT_CHAT_FRAME:AddMessage(SQA.L.CMD_BUTTON)
        DEFAULT_CHAT_FRAME:AddMessage(SQA.L.CMD_SCAN)
        DEFAULT_CHAT_FRAME:AddMessage(SQA.L.CMD_HELP_TEXT)

    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQA:|r " .. SQA.L.UNKNOWN_CMD)
    end
end

-------------------------------------------------
-- Événements principaux - VERSION ULTRA-OPTIMISÉE
-------------------------------------------------

local mainFrame = CreateFrame("Frame")
mainFrame:RegisterEvent("VARIABLES_LOADED")
mainFrame:RegisterEvent("QUEST_LOG_UPDATE")
mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
mainFrame:RegisterEvent("PLAYER_LOGIN")
mainFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
mainFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
-- SUPPRIMÉ : UNIT_QUEST_LOG_CHANGED (trop de spam)

mainFrame:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        -- Enregistrer le temps de chargement
        loadTime = GetTime()

        -- Restaurer la configuration (avec vérifications)
        SQA.enabled = SQA_Config.enabled or true
        SQA.language = SQA_Config.language or "AUTO"

        -- S'assurer que lastObjectives existe
        if not SQA_Config.lastObjectives then
            SQA_Config.lastObjectives = {}
        end
        SQA.lastObjectives = SQA_Config.lastObjectives

        -- Attendre que les locales soient chargées
        local waitForLocales = CreateFrame("Frame")
        local attempts = 0
        waitForLocales:SetScript("OnUpdate", function()
            attempts = attempts + 1

            if SimpleQuestAnnouncer and SimpleQuestAnnouncer.Locales then
                SQA:LoadExternalLocales()
                DEFAULT_CHAT_FRAME:AddMessage(SQA.L.LOADED)
                DEFAULT_CHAT_FRAME:AddMessage(SQA.L.TYPE_HELP)

                SQA.initialized = true
                this:SetScript("OnUpdate", nil)
            elseif attempts > 50 then
                DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000SQA:|r Locales not loaded, using English")
                SQA:SetLanguage("enUS")
                SQA.initialized = true
                this:SetScript("OnUpdate", nil)
            end
        end)

    elseif event == "PLAYER_LOGIN" then
        -- Initialiser le bouton minimap
        SQA:InitializeButton()

    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Premier scan avec LONG délai (pour éviter les annonces au chargement)
        if SQA.enabled and SQA.initialized then
            local delayFrame = CreateFrame("Frame")
            local delayTime = 0
            delayFrame:SetScript("OnUpdate", function()
                delayTime = delayTime + arg1
                if delayTime > 10 then  -- Attendre 10 secondes
                    if SQA.enabled and not SQA.inCombat then
                        ScanQuestLog()
                    end
                    this:SetScript("OnUpdate", nil)
                end
            end)
        end

    elseif event == "QUEST_LOG_UPDATE" then
        -- Utiliser RequestScan avec throttling au lieu de scanner directement
        RequestScan()

    elseif event == "PLAYER_REGEN_DISABLED" then
        -- Entrée en combat - passage en mode économie
        SQA.inCombat = true

    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Sortie de combat - retour en mode normal
        SQA.inCombat = false
        if SQA.enabled then
            -- Scanner après le combat pour rattraper les changements
            RequestScan()
        end
    end
end)

-------------------------------------------------
-- Timer pour scans périodiques + throttling
-------------------------------------------------

local throttleTimer = CreateFrame("Frame")
local periodicTimer = 0
local throttleCheck = 0

throttleTimer:SetScript("OnUpdate", function()
    if not SQA.initialized or not SQA.enabled then
        return
    end

    -- Vérifier le throttling toutes les 0.1 secondes
    throttleCheck = throttleCheck + arg1
    if throttleCheck >= 0.1 then
        throttleCheck = 0

        -- Si un scan est en attente et que le délai minimum est passé
        if pendingScan then
            local currentTime = GetTime()
            local interval = SQA.inCombat and minScanInterval or minScanIntervalOutOfCombat

            if currentTime - lastScanTime >= interval then
                ScanQuestLog()
            end
        end
    end

    -- Scan périodique de sécurité (toutes les 10 secondes)
    periodicTimer = periodicTimer + arg1
    if periodicTimer >= 10 then
        periodicTimer = 0

        -- Scanner seulement si assez de temps écoulé depuis le chargement
        if GetTime() - loadTime >= startupSilence then
            RequestScan()
        end
    end
end)
