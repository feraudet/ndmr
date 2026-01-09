# Roadmap Ndmr

> Dernière mise à jour : 2026-01-09

## Vision

Créer un éditeur de codeplug DMR moderne, multiplateforme et accessible aux débutants, inspiré de qdmr mais avec une interface native sur chaque plateforme (Windows, Linux, macOS, Android, iOS).

## Étapes de développement

### Phase 1 - Fondations (En cours)

- [x] **Feature** Structure Flutter avec Riverpod et Freezed
- [x] **Feature** Modèles de données (Channel, Zone, Contact, ScanList, RadioSettings, Codeplug)
- [x] **Feature** Interface responsive (navigation rail desktop / bottom nav mobile)
- [x] **Feature** Thème clair/sombre automatique
- [x] **Feature** Éditeur de canaux avec support DMR (timeslot, color code)
- [x] **Feature** Gestion des zones et contacts
- [x] **Feature** Sauvegarde/chargement fichiers JSON (.ndmr)
- [x] **Feature** Contacts par défaut (France, Europe, Mondial, Echo Test)
- [x] **Feature** Support multilingue (FR/EN)
- [x] **Docs** Tooltips d'aide pour les termes techniques DMR
- [x] **Fix** Compléter l'ouverture de fichier depuis le dashboard

### Phase 2 - Améliorations UX

- [x] **Feature** Assistant de première configuration (wizard)
- [x] **Feature** Import/export CSV pour les canaux
- [x] **Feature** Import depuis fichiers qdmr (.yaml)
- [x] **Feature** Recherche et filtrage des canaux/contacts
- [x] **Feature** Attribution canaux aux zones (drag & drop)
- [x] **Feature** Validation du codeplug avant export
- [x] **Feature** Raccourcis clavier (desktop)
- [x] **Perf** Gestion des gros codeplugs (debouncing recherche)
- [x] **Feature** Duplication de canaux
- [x] **Feature** Export PDF du codeplug

### Phase 3 - Intégration Radio

- [ ] **Feature** Détection USB des radios connectées
- [ ] **Feature** Lecture du codeplug depuis la radio (Anytone AT-D878UV)
- [ ] **Feature** Écriture du codeplug vers la radio
- [ ] **Feature** Support des firmwares Anytone
- [ ] **Docs** Guide de connexion radio

### Phase 4 - Multi-radios

- [ ] **Feature** Support OpenGD77 / OpenRTX
- [ ] **Feature** Support TYT MD-UV380/390
- [ ] **Feature** Support Radioddity GD-77
- [ ] **Feature** Conversion entre formats de codeplug

### Idées et améliorations futures

- [ ] **Feature** Base de données de relais (repeaterbook.com)
- [ ] **Feature** Carte des relais avec géolocalisation
- [ ] **Feature** Synchronisation cloud des codeplugs
- [ ] **Feature** Mode hors-ligne complet sur mobile
- [ ] **Feature** Thèmes personnalisables
- [x] **Feature** Duplication de contacts/zones
- [x] **Feature** Réorganisation des canaux par drag & drop

## Historique des versions

### v0.5.0 - 2026-01-09
- Optimisation performance (debouncing recherche)
- Duplication de canaux, contacts et zones
- Export PDF du codeplug
- Réorganisation des canaux par drag & drop

### v0.4.0 - 2026-01-08
- Import de fichiers qdmr (.yaml)
- Recherche et filtrage des contacts
- Raccourcis clavier desktop (Cmd/Ctrl+O/S, Cmd/Ctrl+1-5)

### v0.3.0 - 2026-01-08
- Import/export CSV des canaux
- Attribution des canaux aux zones avec drag & drop
- Validation du codeplug avant export
- Écran de détail des zones

### v0.2.0 - 2026-01-08
- Assistant de première configuration (wizard)
- Recherche et filtrage des canaux (par nom, fréquence, mode)
- Écran des réglages amélioré avec tooltips
- Corrections de bugs (ouverture de fichiers)

### v0.1.0 - 2026-01-08
- Version initiale
- Éditeur de codeplug fonctionnel (canaux, zones, contacts, réglages)
- Sauvegarde/chargement JSON
- Interface multilingue FR/EN
- Tooltips d'aide pour débutants
- Contacts DMR français par défaut
