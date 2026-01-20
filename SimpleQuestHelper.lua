-- SimpleQuestHelper pour WoW 1.12 (Lua 5.0)
-- Version optimisée avec acceptation automatique des quêtes

-- Table principale
SimpleQuestHelper = {}
local SQH = SimpleQuestHelper

-------------------------------------------------
-- Configuration sauvegardée - CORRIGÉE
-------------------------------------------------

SQH_Config = SQH_Config or {
    enabled = true,
    language = "AUTO",
    autoAccept = true,       -- Acceptation automatique
    autoComplete = true      -- Rendu automatique
}

-- S'assurer que lastObjectives existe (pour compatibilité avec anciennes sauvegardes)
if not SQH_Config.lastObjectives then
    SQH_Config.lastObjectives = {}
end

SQH.enabled = SQH_Config.enabled
SQH.language = SQH_Config.language
SQH.autoAccept = SQH_Config.autoAccept
SQH.autoComplete = SQH_Config.autoComplete
SQH.lastObjectives = SQH_Config.lastObjectives
SQH.initialized = false
SQH.inCombat = false
SQH.isScanning = false

-- Table pour les quêtes déjà annoncées comme terminées DANS CETTE SESSION
SQH.announcedComplete = {}

-- Temps de chargement pour éviter les annonces au démarrage
local loadTime = 0
local startupSilence = 15  -- Secondes de silence après /reload

-- Throttling des scans
local lastScanTime = 0
local minScanInterval = 0.5  -- Minimum 0.5 secondes entre chaque scan EN COMBAT
local minScanIntervalOutOfCombat = 0.2  -- Plus rapide hors combat
local pendingScan = false

-------------------------------------------------
-- Localisation de base (ANGLAIS par défaut)
-------------------------------------------------

SQH.L = {
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
    BUTTON_CREATED = "Button created",
    CACHE_CLEARED = "Quest cache cleared",
    CACHE_CLEANED = "Cache cleaned"
}

-- Table des locales disponibles
SQH.Locales = {
    ["enUS"] = SQH.L  -- anglais par défaut
}

-------------------------------------------------
-- Fonction pour charger les locales externes
-------------------------------------------------

function SQH:LoadExternalLocales()
    -- Vérifier si la table globale existe
    if not SimpleQuestHelper.Locales then
        return
    end

    -- Copier toutes les locales depuis la table globale
    for lang, localeTable in pairs(SimpleQuestHelper.Locales) do
        if type(localeTable) == "table" then
            SQH.Locales[lang] = localeTable
        end
    end
end

-------------------------------------------------
-- Fonction pour définir la langue
-------------------------------------------------

function SQH:SetLanguage(lang)
    -- Charger toutes les locales d'abord
    SQH:LoadExternalLocales()

    -- Déterminer la langue cible
    local targetLang = lang

    if lang == "AUTO" then
        local clientLang = GetLocale()
        targetLang = clientLang

        -- Si la langue du client n'est pas disponible, utiliser enUS
        if not SQH.Locales[targetLang] then
            targetLang = "enUS"
        end
    end

    -- Vérifier si la langue cible existe
    if not SQH.Locales[targetLang] then
        targetLang = "enUS"
    end

    -- Créer une nouvelle table pour SQH.L
    local newLocale = {}
    for key, value in pairs(SQH.Locales[targetLang]) do
        newLocale[key] = value
    end

    -- S'assurer d'avoir toutes les clés
    for key, value in pairs(SQH.Locales["enUS"]) do
        if not newLocale[key] then
            newLocale[key] = value
        end
    end

    -- Remplacer SQH.L
    SQH.L = newLocale

    -- Sauvegarder la configuration
    SQH.language = lang
    SQH_Config.language = lang
    SQH_Config.enabled = SQH.enabled
    SQH_Config.autoAccept = SQH.autoAccept
    SQH_Config.autoComplete = SQH.autoComplete

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

    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.LANG_SET .. " " .. (langNames[lang] or lang))

    -- Mettre à jour le bouton
    if SQHMinimapButton then
        if SQH.enabled then
            SQHMinimapButton.icon:SetVertexColor(1, 1, 1)
        else
            SQHMinimapButton.icon:SetVertexColor(0.5, 0.5, 0.5)
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

    if not SQH.enabled then return end

    if GetNumPartyMembers() > 0 then
        SendChatMessage(SQH.L.PREFIX .. " " .. msg, "PARTY")
    else
        -- Envoyer dans l'onglet de chat actif
        local targetFrame = SELECTED_CHAT_FRAME

        if targetFrame and type(targetFrame.AddMessage) == "function" then
            targetFrame:AddMessage(SQH.L.PREFIX .. " " .. msg)
        else
            DEFAULT_CHAT_FRAME:AddMessage(SQH.L.PREFIX .. " " .. msg)
        end
    end

    if isComplete then
        UIErrorsFrame:AddMessage(SQH.L.PREFIX .. " " .. SQH.L.COMPLETED, 0, 1, 0, 1, 0.5)
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
-- Scanner les quêtes - VERSION CORRIGÉE DEFINITIVE
-------------------------------------------------

local function ScanQuestLog()
    -- Éviter les scans en cascade
    if SQH.isScanning then return end

    -- Throttling adaptatif selon le combat
    local currentTime = GetTime()
    local interval = SQH.inCombat and minScanInterval or minScanIntervalOutOfCombat

    if currentTime - lastScanTime < interval then
        -- Marquer qu'un scan est en attente
        pendingScan = true
        return
    end

    SQH.isScanning = true
    lastScanTime = currentTime
    pendingScan = false

    -- Ne pas scanner avant l'initialisation
    if not SQH.initialized or not SQH.enabled then
        SQH.isScanning = false
        return
    end

    -- Vérifications de sécurité
    if not GetNumQuestLogEntries or type(GetNumQuestLogEntries) ~= "function" then
        SQH.isScanning = false
        return
    end

    local numEntries = GetNumQuestLogEntries()
    if not numEntries or numEntries <= 0 then
        SQH.isScanning = false
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
                        local oldValue = SQH.lastObjectives[key]

                        -- Extraire les nombres pour la comparaison
                        local current, total = ExtractNumbers(text)

                        if current and total then
                            -- Sauvegarder la valeur numérique actuelle
                            local numericValue = current .. "/" .. total

                            -- Annoncer seulement si la valeur a CHANGÉ et n'est PAS 0/quelquechose
                            if oldValue and oldValue ~= numericValue then
                                -- Sauvegarder la nouvelle valeur
                                SQH.lastObjectives[key] = numericValue
                                SQH_Config.lastObjectives[key] = numericValue

                                -- Ne pas annoncer si c'est 0/X (première fois qu'on voit la quête)
                                if current > 0 then
                                    SendAnnouncement("|cFFFFFF00" .. title .. "|r - " .. text)
                                end
                            elseif not oldValue then
                                -- Première fois qu'on voit cet objectif, sauvegarder mais ne pas annoncer
                                SQH.lastObjectives[key] = numericValue
                                SQH_Config.lastObjectives[key] = numericValue
                            end
                        end
                    end
                end
            end

            -- Vérifier si la quête est terminée
            if isComplete == 1 then
                -- Vérifier si on a DÉJÀ annoncé cette quête comme terminée dans CETTE SESSION
                if not SQH.announcedComplete[title] then
                    -- Première fois qu'on la voit terminée dans cette session, annoncer
                    SQH.announcedComplete[title] = true
                    SendAnnouncement("|cFF00FF00" .. title .. " " .. SQH.L.COMPLETED .. "|r", true)
                end
            else
                -- Si la quête n'est plus complète, réinitialiser le flag de session
                SQH.announcedComplete[title] = nil
            end
        end
    end

    -- Nettoyer le cache des quêtes qui ne sont plus dans le journal
    for key, _ in pairs(SQH.lastObjectives) do
        local questTitle = ExtractQuestNameFromKey(key)
        if questTitle and not currentQuests[questTitle] then
            -- Cette quête n'est plus dans le journal, la supprimer du cache
            SQH.lastObjectives[key] = nil
            SQH_Config.lastObjectives[key] = nil
            -- Aussi supprimer du cache de session
            SQH.announcedComplete[questTitle] = nil
        end
    end

    SQH.isScanning = false
end

-------------------------------------------------
-- Scanner avec THROTTLING
-------------------------------------------------

local function RequestScan()
    if SQH.enabled and SQH.initialized then
        local currentTime = GetTime()
        local interval = SQH.inCombat and minScanInterval or minScanIntervalOutOfCombat

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
-- FONCTIONS D'ACCEPTATION AUTOMATIQUE DES QUÊTES
-------------------------------------------------

local function SQHAutoAcceptQuests()
    if not SQH.autoAccept then return false end

    -- Méthode 1: Système GOSSIP (WoW 1.12)
    local gossipData = {GetGossipAvailableQuests()}
    if gossipData and gossipData[1] then
        SelectGossipAvailableQuest(1)
        return true
    end

    -- Méthode 2: Ancien système QUEST_GREETING
    local numAvailable = GetNumAvailableQuests()
    if numAvailable and numAvailable > 0 then
        SelectAvailableQuest(1)
        return true
    end

    -- Méthode 3: Quêtes actives terminées via gossip
    local activeData = {GetGossipActiveQuests()}
    if activeData and activeData[1] then
        local numQuests = table.getn(activeData) / 6
        for i = 1, numQuests do
            local baseIndex = (i-1)*6
            if activeData[baseIndex + 3] then  -- isComplete
                SelectGossipActiveQuest(i)
                return true
            end
        end
    end

    -- Méthode 4: Quêtes actives terminées (ancien système)
    local numActive = GetNumActiveQuests()
    if numActive and numActive > 0 then
        for i = 1, numActive do
            local title, complete = GetActiveTitle(i)
            if complete then
                SelectActiveQuest(i)
                return true
            end
        end
    end

    return false
end

-------------------------------------------------
-- Gestionnaires d'événements pour l'acceptation auto
-------------------------------------------------

function SQH:HandleGossipShow()
    SQHAutoAcceptQuests()
end

function SQH:HandleQuestGreeting()
    SQHAutoAcceptQuests()
end

function SQH:HandleQuestDetail()
    if SQH.autoAccept then
        AcceptQuest()
    end
end

function SQH:HandleQuestProgress()
    if SQH.autoComplete and IsQuestCompletable() then
        CompleteQuest()
    end
end

function SQH:HandleQuestComplete()
    if SQH.autoComplete then
        local numChoices = GetNumQuestChoices()
        if numChoices == 0 then
            GetQuestReward()
        -- Note: Si numChoices > 0, on laisse le joueur choisir manuellement
        end
    end
end

-------------------------------------------------
-- Menu déroulant des langues
-------------------------------------------------

local function ShowLanguageMenu()
    -- Vérifier si le menu existe déjà, sinon le créer
    if not _G["SQHLanguageMenu"] then
        CreateFrame("Frame", "SQHLanguageMenu", UIParent, "UIDropDownMenuTemplate")
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
    UIDropDownMenu_Initialize(_G["SQHLanguageMenu"], function()
        for i = 1, 8 do
            local lang = languageList[i]
            local info = UIDropDownMenu_CreateInfo()
            info.text = lang.text
            info.value = lang.value
            info.func = function()
                SQH:SetLanguage(lang.value)
            end
            info.checked = (SQH.language == lang.value)
            info.notCheckable = false
            UIDropDownMenu_AddButton(info)
        end
    end)

    -- Afficher le menu
    ToggleDropDownMenu(1, nil, _G["SQHLanguageMenu"], "cursor", 0, 0)
end

-- ===================================================
-- INITIALISATION DU BOUTON MINIMAP POUR SQH
-- ===================================================

function SQH:InitializeButton()
    if not Minimap then return false end

    if SQHMinimapButton then
        SQHMinimapButton:Show()
        return true
    end

    self:CreateButton()
    return true
end

-------------------------------------------------
-- Fonction pour créer le bouton minimap
-------------------------------------------------

function SQH:CreateButton()
    -- D'abord détruire l'ancien bouton s'il existe
    if SQHMinimapButton then
        SQHMinimapButton:Hide()
        SQHMinimapButton = nil
    end

    if self.minimapButton then return end

    -- Création de la frame
    local button = CreateFrame("Button", "SQHMinimapButton", Minimap)
    button:SetWidth(40)
    button:SetHeight(40)
    button:SetFrameStrata("MEDIUM")

    -- Si pfUI n'est pas présent, utiliser une position par défaut
    if not (pfUI and pfUI.minimap) then
        button:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 10, -75)
    end

    -- Cercle doré autour de l'image
    button.goldCircle = button:CreateTexture(nil, "ARTWORK")
    button.goldCircle:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
    button.goldCircle:SetWidth(32)
    button.goldCircle:SetHeight(32)
    button.goldCircle:SetPoint("CENTER", 0, -3)
    button.goldCircle:SetTexCoord(0, 0.6, 0, 0.6)

    -- Icône personnalisée
    button.icon = button:CreateTexture(nil, "BACKGROUND")
    button.icon:SetTexture("Interface\\AddOns\\SimpleQuestHelper\\icon")
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
    -- GESTION DU DRAG
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
    -- COMPORTEMENT AU SURVOL ET CLIC - MODIFIÉ ET LOCALISÉ
    -- ===================================================

    button:SetAlpha(0.9)

    button:SetScript("OnEnter", function()
        this:SetAlpha(1)
        if GameTooltip then
            GameTooltip:SetOwner(this, "ANCHOR_LEFT")
            GameTooltip:SetText("|cFF00CCFF" .. SQH.L.TOOLTIP_TITLE .. "|r")

            -- Clic gauche
            local leftText = SQH.L.TOOLTIP_LEFT_CLICK .. ": " ..
                (SQH.enabled and SQH.L.TOOLTIP_DEACTIVATE or SQH.L.TOOLTIP_ACTIVATE) .. " " .. SQH.L.TOOLTIP_STATUS_ANNOUNCE
            GameTooltip:AddLine(leftText, 1, 1, 1)

            -- Shift + Clic gauche
            GameTooltip:AddLine(SQH.L.TOOLTIP_LEFT_SHIFT .. ": " .. SQH.L.TOOLTIP_CHANGE_LANG, 1, 1, 1)

            -- Alt + Clic gauche
            GameTooltip:AddLine(SQH.L.TOOLTIP_LEFT_ALT .. ": " .. SQH.L.TOOLTIP_SCAN_QUESTS, 1, 1, 1)

            -- Clic droit
            local rightText = SQH.L.TOOLTIP_RIGHT_CLICK .. ": " ..
                (SQH.autoAccept and SQH.L.TOOLTIP_DEACTIVATE or SQH.L.TOOLTIP_ACTIVATE) .. " " .. SQH.L.TOOLTIP_STATUS_AUTOACCEPT
            GameTooltip:AddLine(rightText, 1, 1, 1)

            -- Shift + Clic droit
            local rightShiftText = SQH.L.TOOLTIP_RIGHT_SHIFT .. ": " ..
                (SQH.autoComplete and SQH.L.TOOLTIP_DEACTIVATE or SQH.L.TOOLTIP_ACTIVATE) .. " " .. SQH.L.TOOLTIP_STATUS_AUTOCOMPLETE
            GameTooltip:AddLine(rightShiftText, 1, 1, 1)

            -- Alt + Clic droit
            GameTooltip:AddLine(SQH.L.TOOLTIP_RIGHT_ALT .. ": " .. SQH.L.TOOLTIP_CLEAR_CACHE, 1, 1, 1)

            GameTooltip:AddLine(" ")
            GameTooltip:AddLine(SQH.L.TOOLTIP_STATUS .. ":", 1, 1, 1)

            -- Statut annonces
            local announceStatus = SQH.L.TOOLTIP_STATUS_ANNOUNCE .. ": " ..
                (SQH.enabled and "|cFF00FF00" .. SQH.L.TOOLTIP_ON .. "|r" or "|cFFFF0000" .. SQH.L.TOOLTIP_OFF .. "|r")
            GameTooltip:AddLine(announceStatus, 1, 1, 1)

            -- Statut auto-accept
            local autoAcceptStatus = SQH.L.TOOLTIP_STATUS_AUTOACCEPT .. ": " ..
                (SQH.autoAccept and "|cFF00FF00" .. SQH.L.TOOLTIP_ON .. "|r" or "|cFFFF0000" .. SQH.L.TOOLTIP_OFF .. "|r")
            GameTooltip:AddLine(autoAcceptStatus, 1, 1, 1)

            -- Statut auto-complete
            local autoCompleteStatus = SQH.L.TOOLTIP_STATUS_AUTOCOMPLETE .. ": " ..
                (SQH.autoComplete and "|cFF00FF00" .. SQH.L.TOOLTIP_ON .. "|r" or "|cFFFF0000" .. SQH.L.TOOLTIP_OFF .. "|r")
            GameTooltip:AddLine(autoCompleteStatus, 1, 1, 1)

            GameTooltip:Show()
        end
    end)

    button:SetScript("OnLeave", function()
        this:SetAlpha(0.9)
        if GameTooltip then
            GameTooltip:Hide()
        end
    end)

    button:SetScript("OnMouseUp", function()
        local buttonName = arg1
        local isShiftKeyDown = IsShiftKeyDown()
        local isAltKeyDown = IsAltKeyDown()

        -- Clic gauche
        if buttonName == "LeftButton" then
            if isShiftKeyDown then
                -- Shift + Clic gauche: Changer la langue
                ShowLanguageMenu()
            elseif isAltKeyDown then
                -- Alt + Clic gauche: Scanner les quêtes
                if SQH.initialized then
                    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.SCAN_START)
                    ScanQuestLog()
                    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.SCAN_END)
                else
                    DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000SQH:|r Not initialized yet")
                end
            else
                -- Clic gauche simple: Activer/Désactiver annonces
                SQH.enabled = not SQH.enabled
                SQH_Config.enabled = SQH.enabled

                if SQH.enabled then
                    this.icon:SetVertexColor(1, 1, 1)
                    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.ENABLED)
                else
                    this.icon:SetVertexColor(0.5, 0.5, 0.5)
                    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.DISABLED)
                end
            end

        -- Clic droit
        elseif buttonName == "RightButton" then
            if isShiftKeyDown then
                -- Shift + Clic droit: Activer/Désactiver auto-complete
                SQH.autoComplete = not SQH.autoComplete
                SQH_Config.autoComplete = SQH.autoComplete
                if SQH.autoComplete then
                    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.AUTO_COMPLETE_ON)
                else
                    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.AUTO_COMPLETE_OFF)
                end
            elseif isAltKeyDown then
                -- Alt + Clic droit: Nettoyer le cache
                SQH.lastObjectives = {}
                SQH_Config.lastObjectives = {}
                SQH.announcedComplete = {}
                DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.CACHE_CLEARED)
            else
                -- Clic droit simple: Activer/Désactiver auto-accept
                SQH.autoAccept = not SQH.autoAccept
                SQH_Config.autoAccept = SQH.autoAccept
                if SQH.autoAccept then
                    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.AUTO_ACCEPT_ON)
                else
                    DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.AUTO_ACCEPT_OFF)
                end
            end
        end
    end)

    -- ===================================================
    -- VISIBILITÉ
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

    -- Enregistrer le bouton comme propriété de SQH
    self.minimapButton = button

    return button
end

-------------------------------------------------
-- Commandes slash
-------------------------------------------------

SLASH_SIMPLEQUESTHELPER1 = "/sqh"
SlashCmdList["SIMPLEQUESTHELPER"] = function(msg)
    msg = string.lower(msg or "")

    if msg == "on" then
        SQH.enabled = true
        SQH_Config.enabled = true
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.ENABLED)

        if SQHMinimapButton then
            SQHMinimapButton.icon:SetVertexColor(1, 1, 1)
        end

    elseif msg == "off" then
        SQH.enabled = false
        SQH_Config.enabled = false
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.DISABLED)

        if SQHMinimapButton then
            SQHMinimapButton.icon:SetVertexColor(0.5, 0.5, 0.5)
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
            SQH:SetLanguage(langs[num][3])
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFF" .. SQH.L.LANG_LIST .. "|r")
            for i = 1, 8 do
                local lang = langs[i]
                DEFAULT_CHAT_FRAME:AddMessage(lang[1] .. ". " .. lang[2])
            end
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFFFF00" .. SQH.L.LANG_USAGE .. "|r")
        end

    elseif msg == "button" then
        if not SQHMinimapButton then
            SQH:CreateButton()
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.BUTTON_CREATED)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.BUTTON_EXISTS)
        end

    elseif msg == "scan" then
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.SCAN_START)
        if SQH.initialized then
            ScanQuestLog()
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.SCAN_END)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000SQH:|r Not initialized yet")
        end

    elseif msg == "clear" then
        SQH.lastObjectives = {}
        SQH_Config.lastObjectives = {}
        SQH.announcedComplete = {}
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.CACHE_CLEARED)

    elseif msg == "autoaccept" then
        SQH.autoAccept = not SQH.autoAccept
        SQH_Config.autoAccept = SQH.autoAccept
        if SQH.autoAccept then
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.AUTO_ACCEPT_ON)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.AUTO_ACCEPT_OFF)
        end

    elseif msg == "autocomplete" then
        SQH.autoComplete = not SQH.autoComplete
        SQH_Config.autoComplete = SQH.autoComplete
        if SQH.autoComplete then
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.AUTO_COMPLETE_ON)
        else
            DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.AUTO_COMPLETE_OFF)
        end

    elseif msg == "help" or msg == "" or msg == "?" then
        DEFAULT_CHAT_FRAME:AddMessage(SQH.L.CMD_HELP)
        DEFAULT_CHAT_FRAME:AddMessage(SQH.L.CMD_ON)
        DEFAULT_CHAT_FRAME:AddMessage(SQH.L.CMD_OFF)
        DEFAULT_CHAT_FRAME:AddMessage(SQH.L.CMD_LANG)
        DEFAULT_CHAT_FRAME:AddMessage(SQH.L.CMD_BUTTON)
        DEFAULT_CHAT_FRAME:AddMessage(SQH.L.CMD_SCAN)
        DEFAULT_CHAT_FRAME:AddMessage(SQH.L.CMD_AUTO_ACCEPT)
        DEFAULT_CHAT_FRAME:AddMessage(SQH.L.CMD_AUTO_COMPLETE)
        DEFAULT_CHAT_FRAME:AddMessage(SQH.L.CMD_HELP_TEXT)

    else
        DEFAULT_CHAT_FRAME:AddMessage("|cFF00CCFFSQH:|r " .. SQH.L.UNKNOWN_CMD)
    end
end

-------------------------------------------------
-- Événements principaux
-- AVEC CORRECTION POUR LA LANGUE AU CHARGEMENT
-------------------------------------------------

local mainFrame = CreateFrame("Frame")
mainFrame:RegisterEvent("VARIABLES_LOADED")
mainFrame:RegisterEvent("QUEST_LOG_UPDATE")
mainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
mainFrame:RegisterEvent("PLAYER_LOGIN")
mainFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
mainFrame:RegisterEvent("PLAYER_REGEN_DISABLED")

-- Événements pour l'acceptation automatique
mainFrame:RegisterEvent("QUEST_PROGRESS")
mainFrame:RegisterEvent("QUEST_COMPLETE")
mainFrame:RegisterEvent("QUEST_DETAIL")
mainFrame:RegisterEvent("GOSSIP_SHOW")
mainFrame:RegisterEvent("QUEST_GREETING")

mainFrame:SetScript("OnEvent", function()
    if event == "VARIABLES_LOADED" then
        -- Enregistrer le temps de chargement
        loadTime = GetTime()

        -- Restaurer la configuration (avec vérifications)
        SQH.enabled = SQH_Config.enabled or true
        SQH.language = SQH_Config.language or "AUTO"
        SQH.autoAccept = SQH_Config.autoAccept or true
        SQH.autoComplete = SQH_Config.autoComplete or true

        -- S'assurer que lastObjectives existe
        if not SQH_Config.lastObjectives then
            SQH_Config.lastObjectives = {}
        end
        SQH.lastObjectives = SQH_Config.lastObjectives

        -- Initialiser le cache de session
        SQH.announcedComplete = {}

        -- Attendre que les locales soient chargées
        local waitForLocales = CreateFrame("Frame")
        local attempts = 0
        waitForLocales:SetScript("OnUpdate", function()
            attempts = attempts + 1

            if SimpleQuestHelper and SimpleQuestHelper.Locales then
                SQH:LoadExternalLocales()

                -- CORRECTION CRITIQUE : Réappliquer la langue sauvegardée
                if SQH.language then
                    SQH:SetLanguage(SQH.language)
                else
                    SQH:SetLanguage("AUTO")
                end

                DEFAULT_CHAT_FRAME:AddMessage(SQH.L.LOADED)
                DEFAULT_CHAT_FRAME:AddMessage(SQH.L.TYPE_HELP)

                SQH.initialized = true
                this:SetScript("OnUpdate", nil)
            elseif attempts > 50 then
                DEFAULT_CHAT_FRAME:AddMessage("|cFFFF0000SQH:|r Locales not loaded, using English")
                SQH:SetLanguage("enUS")
                SQH.initialized = true
                this:SetScript("OnUpdate", nil)
            end
        end)

    elseif event == "PLAYER_LOGIN" then
        -- Initialiser le bouton minimap
        SQH:InitializeButton()

    elseif event == "PLAYER_ENTERING_WORLD" then
        -- Premier scan avec LONG délai (pour éviter les annonces au chargement)
        if SQH.enabled and SQH.initialized then
            local delayFrame = CreateFrame("Frame")
            local delayTime = 0
            delayFrame:SetScript("OnUpdate", function()
                delayTime = delayTime + arg1
                if delayTime > 10 then
                    if SQH.enabled and not SQH.inCombat then
                        ScanQuestLog()
                    end
                    this:SetScript("OnUpdate", nil)
                end
            end)
        end

    elseif event == "QUEST_LOG_UPDATE" then
        -- Utiliser RequestScan avec throttling
        RequestScan()

    elseif event == "PLAYER_REGEN_DISABLED" then
        -- Entrée en combat
        SQH.inCombat = true

    elseif event == "PLAYER_REGEN_ENABLED" then
        -- Sortie de combat
        SQH.inCombat = false
        if SQH.enabled then
            RequestScan()
        end

    -- ===================================================
    -- ÉVÉNEMENTS POUR L'ACCEPTATION AUTOMATIQUE
    -- ===================================================

    elseif event == "GOSSIP_SHOW" then
        SQH:HandleGossipShow()

    elseif event == "QUEST_GREETING" then
        SQH:HandleQuestGreeting()

    elseif event == "QUEST_DETAIL" then
        SQH:HandleQuestDetail()

    elseif event == "QUEST_PROGRESS" then
        SQH:HandleQuestProgress()

    elseif event == "QUEST_COMPLETE" then
        SQH:HandleQuestComplete()

    end
end)

-------------------------------------------------
-- Timer pour scans périodiques + throttling
-------------------------------------------------

local throttleTimer = CreateFrame("Frame")
local periodicTimer = 0
local throttleCheck = 0

throttleTimer:SetScript("OnUpdate", function()
    if not SQH.initialized or not SQH.enabled then
        return
    end

    -- Vérifier le throttling toutes les 0.1 secondes
    throttleCheck = throttleCheck + arg1
    if throttleCheck >= 0.1 then
        throttleCheck = 0

        -- Si un scan est en attente et que le délai minimum est passé
        if pendingScan then
            local currentTime = GetTime()
            local interval = SQH.inCombat and minScanInterval or minScanIntervalOutOfCombat

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
