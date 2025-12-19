# Simple Quest Announcer - Addon World of Warcraft 1.12

<p align="center">
  <img src="https://img.shields.io/badge/Version-1.1-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/WoW-1.12.x-orange.svg" alt="WoW Version">
  <img src="https://img.shields.io/badge/Lua-5.0-green.svg" alt="Lua Version">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License">
</p>

## 🎯 Description

Simple Quest Announcer est un addon léger et optimisé pour World of Warcraft Classic (version 1.12) qui annonce automatiquement la progression et l'achèvement de vos quêtes dans le chat de groupe.

## ✨ Fonctionnalités

- **🎤 Annonces intelligentes** : Partage votre progression de quête avec votre groupe
- **⚡ Optimisation anti-crash** : Code spécialement conçu pour la stabilité
- **🌍 Multi-langues** : Support de 7 langues différentes
- **🎨 Interface intuitive** : Bouton sur la minicarte avec menu contextuel
- **🔧 Configuration simple** : Commandes slash faciles à utiliser
- **💾 Sauvegarde automatique** : Mémorise vos préférences entre sessions

## 📦 Installation

1. **Télécharger l'addon** :
   - **Option 1** : Cliquez sur le bouton vert "Code" puis "Download ZIP"
   - **Option 2** : Clonez le repository avec Git :
     ```bash
     git clone https://github.com/votre-utilisateur/SimpleQuestAnnouncer.git
     ```

2. **Installer l'addon** :
   - Extrayez le dossier `SimpleQuestAnnouncer` (contenu dans le ZIP) dans votre répertoire d'addons :
     ```
     Wow/Interface/AddOns/
     ```
   - Assurez-vous que le chemin final soit :
     ```
     Wow/Interface/AddOns/SimpleQuestAnnouncer/
     ```

3. **Activer l'addon** :
   - Lancez World of Warcraft Classic (version 1.12)
   - À l'écran de sélection de personnage, cliquez sur le bouton "AddOns"
   - Vérifiez que "SimpleQuestAnnouncer" est coché
   - Assurez-vous que "Load out of date AddOns" est coché si nécessaire

## 🚀 Utilisation

### Commandes Slash

| Commande | Description |
|----------|-------------|
| `/sqa on` | Active les annonces |
| `/sqa off` | Désactive les annonces |
| `/sqa lang` | Change la langue |
| `/sqa scan` | Force un scan des quêtes |
| `/sqa clear` | Vide le cache des quêtes |
| `/sqa help` | Affiche l'aide |
| `/sqa button` | Recrée le bouton minimap |

### Bouton Minimap
- **Clic gauche** : Active/désactive l'addon
- **Clic droit** : Ouvre le menu de sélection de langue
- **Glisser-déposer** : Déplace le bouton sur la minicarte

## 🌐 Langues Supportées

| Code | Langue | Statut |
|------|--------|--------|
| Auto | Détection automatique | ✅ |
| enUS | Anglais (US) | ✅ |
| frFR | Français | ✅ |
| deDE | Allemand | ✅ |
| esES | Espagnol | ✅ |
| itIT | Italien | ✅ |
| ptBR | Portugais (Brésil) | ✅ |
| ruRU | Russe | ✅ |

## ⚙️ Configuration

L'addon sauvegarde automatiquement vos paramètres dans `SQA_Config` :

```lua
SQA_Config = {
    enabled = true,      -- Activer/désactiver l'addon
    language = "AUTO",   -- Langue choisie
    lastObjectives = {}  -- Cache des objectifs de quête
}
```

## 🔧 Optimisations Techniques
Throttling intelligent : Scans adaptés selon l'état de combat
Silence au démarrage : Aucune annonce pendant 15 secondes après /reload
Cache nettoyé : Suppression automatique des quêtes terminées
Compatibilité pfUI : Intégration avec l'UI populaire pfUI

## 🐛 Dépannage
Problèmes courants :
Le bouton n'apparaît pas : Tapez /sqa button pour le recréer
Vérifiez que l'addon est activé
Pas d'annonces : Vérifiez que l'addon est activé (/sqa on)
Erreurs Lua : Tapez /console scriptErrors 1 pour voir les erreurs
