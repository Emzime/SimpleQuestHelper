# Simple Quest Helper - Addon World of Warcraft 1.12

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.2-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/WoW-1.12.x-orange.svg" alt="WoW Version">
  <img src="https://img.shields.io/badge/Lua-5.0-green.svg" alt="Lua Version">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
</p>

## 🎯 Description

**Simple Quest Helper** est un addon complet et optimisé pour World of Warcraft Classic (version 1.12) qui automatise la gestion des quêtes. Il annonce la progression, accepte et complète automatiquement les quêtes, et améliore votre expérience de jeu.

## ✨ Fonctionnalités Principales

### 📢 **Annonces Intelligentes**
- Partage automatiquement la progression des quêtes avec votre groupe
- Annonce la complétion des quêtes avec message d'erreur UI
- Support du chat de groupe et chat normal

### 🤖 **Automatisation Complète**
- **Auto-acceptation** : Accepte automatiquement les nouvelles quêtes
- **Auto-complétion** : Complète automatiquement les quêtes terminées
- Gestion intelligente des récompenses (choix manuel si plusieurs options)

### 🌍 **Multi-langues Complet**
- Support de 7 langues différentes + détection automatique
- Interface localisée avec menus déroulants
- Commandes slash traduites

### 🎨 **Interface Avancée**
- Bouton sur la minicarte avec interactions riches
- Tooltips détaillés avec statuts en temps réel
- Menu de langue contextuel
- Support de pfUI et autres interfaces

### ⚡ **Optimisations Techniques**
- **Code stable** : Spécialement conçu pour WoW 1.12 (Lua 5.0)
- **Throttling intelligent** : Adapte les scans selon l'état de combat
- **Cache optimisé** : Mémorise uniquement les quêtes actives
- **Silence au démarrage** : Aucune annonce pendant 15s après /reload

## 📦 Installation

### 1. **Télécharger l'addon**
   - **Option 1** : Cliquez sur le bouton vert "Code" puis "Download ZIP"
   - **Option 2** : Clonez le repository avec Git :
     ```bash
     git clone https://github.com/Emzime/SimpleQuestHelper.git
     ```

### 2. **Installer l'addon**
   - Extrayez le dossier `SimpleQuestHelper` dans votre répertoire d'addons :
     ```
     World of Warcraft/Interface/AddOns/
     ```
   - Assurez-vous que le chemin final soit :
     ```
     World of Warcraft/Interface/AddOns/SimpleQuestHelper/
     ```

### 3. **Activer l'addon**
   - Lancez World of Warcraft Classic (version 1.12)
   - À l'écran de sélection de personnage, cliquez sur "AddOns"
   - Cochez "Simple Quest Helper"
   - Cochez "Load out of date AddOns" si nécessaire

## 🚀 Utilisation

### Commandes Slash (Tapez `/sqh`)

| Commande | Description | Exemple |
|----------|-------------|---------|
| `/sqh on` | Active les annonces | `/sqh on` |
| `/sqh off` | Désactive les annonces | `/sqh off` |
| `/sqh lang` | Change la langue | `/sqh lang` |
| `/sqh autoaccept` | Active/désactive l'auto-acceptation | `/sqh autoaccept` |
| `/sqh autocomplete` | Active/désactive l'auto-complétion | `/sqh autocomplete` |
| `/sqh scan` | Force un scan des quêtes | `/sqh scan` |
| `/sqh clear` | Vide le cache des quêtes | `/sqh clear` |
| `/sqh button` | Recrée le bouton minimap | `/sqh button` |
| `/sqh help` | Affiche l'aide complète | `/sqh help` |

### 🎮 **Bouton Minimap - Interactions Avancées**

#### **Clic Gauche**
- **Simple** : Active/désactive les annonces
- **Shift + Clic** : Ouvre le menu de langue
- **Alt + Clic** : Scanner les quêtes manuellement

#### **Clic Droit**
- **Simple** : Active/désactive l'auto-acceptation
- **Shift + Clic** : Active/désactive l'auto-complétion
- **Alt + Clic** : Vide le cache des quêtes

#### **Survol**
- Affiche un tooltip détaillé avec :
  - Statut actuel (annonces, auto-accept, auto-complete)
  - Instructions d'utilisation
  - Toutes les combinaisons de touches

## 🌐 Langues Supportées

| Code | Langue | Statut |
|------|--------|--------|
| `AUTO` | Détection automatique | ✅ |
| `enUS` | Anglais (US) | ✅ |
| `frFR` | Français | ✅ |
| `deDE` | Allemand | ✅ |
| `esES` | Espagnol | ✅ |
| `itIT` | Italien | ✅ |
| `ptBR` | Portugais (Brésil) | ✅ |
| `ruRU` | Russe | ✅ |

## ⚙️ Configuration Technique

L'addon sauvegarde automatiquement vos paramètres dans `SQH_Config` :

```lua
SQH_Config = {
    enabled = true,          -- Activer/désactiver les annonces
    language = "AUTO",       -- Langue choisie
    autoAccept = true,       -- Auto-acceptation des quêtes
    autoComplete = true,     -- Auto-complétion des quêtes
    lastObjectives = {}      -- Cache des objectifs de quête
}
