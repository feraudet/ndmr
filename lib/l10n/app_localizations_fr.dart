// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class L10nFr extends L10n {
  L10nFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Ndmr';

  @override
  String get navDashboard => 'Accueil';

  @override
  String get navChannels => 'Canaux';

  @override
  String get navZones => 'Zones';

  @override
  String get navContacts => 'Contacts';

  @override
  String get navSettings => 'Réglages';

  @override
  String get welcomeTitle => 'Bienvenue sur Ndmr';

  @override
  String get welcomeSubtitle =>
      'Créez ou ouvrez une configuration pour commencer';

  @override
  String get newConfig => 'Nouvelle configuration';

  @override
  String get openFile => 'Ouvrir un fichier';

  @override
  String get saveFile => 'Enregistrer';

  @override
  String get configName => 'Nouvelle configuration';

  @override
  String get channels => 'Canaux';

  @override
  String get channelsEmpty => 'Aucun canal';

  @override
  String get channelsEmptyHint => 'Ajoutez votre premier canal pour commencer';

  @override
  String get addChannel => 'Ajouter un canal';

  @override
  String get editChannel => 'Modifier le canal';

  @override
  String get duplicateChannel => 'Dupliquer le canal';

  @override
  String get deleteChannel => 'Supprimer le canal';

  @override
  String deleteChannelConfirm(String name) {
    return 'Supprimer \"$name\" ?';
  }

  @override
  String get zones => 'Zones';

  @override
  String get zonesEmpty => 'Aucune zone';

  @override
  String get zonesEmptyHint => 'Les zones permettent d\'organiser vos canaux';

  @override
  String get addZone => 'Ajouter une zone';

  @override
  String get editZone => 'Modifier la zone';

  @override
  String get duplicateZone => 'Dupliquer la zone';

  @override
  String get deleteZone => 'Supprimer la zone';

  @override
  String zoneChannelCount(int count) {
    return '$count canaux';
  }

  @override
  String get contacts => 'Contacts';

  @override
  String get contactsEmpty => 'Aucun contact';

  @override
  String get contactsEmptyHint =>
      'Ajoutez des groupes de discussion et contacts privés';

  @override
  String get addContact => 'Ajouter un contact';

  @override
  String get editContact => 'Modifier le contact';

  @override
  String get duplicateContact => 'Dupliquer le contact';

  @override
  String get deleteContact => 'Supprimer le contact';

  @override
  String get settings => 'Réglages';

  @override
  String get settingsIdentity => 'Identité';

  @override
  String get settingsDisplay => 'Affichage';

  @override
  String get settingsSaved => 'Réglages enregistrés';

  @override
  String get fieldName => 'Nom';

  @override
  String get fieldRxFrequency => 'Fréquence RX (MHz)';

  @override
  String get fieldTxFrequency => 'Fréquence TX (MHz)';

  @override
  String get fieldMode => 'Mode';

  @override
  String get fieldPower => 'Puissance';

  @override
  String get fieldTimeslot => 'Timeslot';

  @override
  String get fieldColorCode => 'Color Code';

  @override
  String get fieldDmrId => 'DMR ID';

  @override
  String get fieldCallsign => 'Indicatif';

  @override
  String get fieldIntroLine1 => 'Ligne d\'intro 1';

  @override
  String get fieldIntroLine2 => 'Ligne d\'intro 2';

  @override
  String get fieldCallType => 'Type d\'appel';

  @override
  String get modeAnalog => 'ANALOGIQUE';

  @override
  String get modeDigital => 'NUMÉRIQUE';

  @override
  String get powerLow => 'FAIBLE';

  @override
  String get powerMedium => 'MOYEN';

  @override
  String get powerHigh => 'ÉLEVÉ';

  @override
  String get powerTurbo => 'TURBO';

  @override
  String get callTypeGroup => 'GROUPE';

  @override
  String get callTypePrivate => 'PRIVÉ';

  @override
  String get callTypeAllCall => 'APPEL GÉNÉRAL';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get nameRequired => 'Le nom est requis';

  @override
  String get fieldRequired => 'Requis';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get outOfRange => 'Hors limites';

  @override
  String get noConfigLoaded => 'Aucune configuration chargée';

  @override
  String get noConfigToSave => 'Aucune configuration à enregistrer';

  @override
  String configLoaded(String name) {
    return 'Configuration \"$name\" chargée';
  }

  @override
  String get configSaved => 'Configuration enregistrée';

  @override
  String get helpChannel =>
      'Un canal est une fréquence pré-enregistrée, comme une station de radio favorite. Il contient tous les paramètres nécessaires pour communiquer.';

  @override
  String get helpZone =>
      'Une zone est un dossier pour organiser vos canaux. Par exemple : \'Relais locaux\', \'Hotspot maison\', \'Simplex\'.';

  @override
  String get helpContact =>
      'Un contact est un groupe de discussion (Talk Group) ou une personne. C\'est comme un salon Discord ou un numéro de téléphone.';

  @override
  String get helpTimeslot =>
      'Le DMR divise chaque fréquence en 2 créneaux temporels (TS1 et TS2). Chaque relais utilise un timeslot spécifique pour chaque talk group.';

  @override
  String get helpColorCode =>
      'Le Color Code (0-15) est comme un code d\'accès au relais. Vous devez utiliser le même que celui configuré sur le relais.';

  @override
  String get helpDmrId =>
      'Votre DMR ID est un identifiant unique à 7 chiffres. Obtenez-le gratuitement sur radioid.net avec votre licence radioamateur.';

  @override
  String get helpCallsign =>
      'Votre indicatif radioamateur officiel (ex: F1TMV).';

  @override
  String get helpRxFrequency =>
      'Fréquence de réception : celle sur laquelle vous écoutez.';

  @override
  String get helpTxFrequency =>
      'Fréquence d\'émission : celle sur laquelle vous transmettez. Souvent différente sur les relais.';

  @override
  String get helpPower =>
      'Puissance d\'émission. Utilisez la puissance minimale nécessaire pour économiser la batterie.';

  @override
  String get helpTalkGroup =>
      'Un Talk Group est un groupe de discussion. Le TG 208 regroupe tous les radioamateurs français, le TG 9 est local au relais.';

  @override
  String get searchChannelsHint => 'Rechercher par nom ou fréquence...';

  @override
  String get searchContactsHint => 'Rechercher par nom ou DMR ID...';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get unnamed => '(sans nom)';

  @override
  String get wizardTitle => 'Bienvenue sur Ndmr';

  @override
  String get wizardWelcomeTitle => 'Configurez votre radio DMR';

  @override
  String get wizardWelcomeText =>
      'Ndmr vous permet de programmer facilement votre radio DMR.\n\nCe guide va vous aider à configurer les informations de base.';

  @override
  String get wizardIdentityTitle => 'Votre identité';

  @override
  String get wizardIdentityText =>
      'Ces informations vous identifient sur le réseau DMR mondial.';

  @override
  String get wizardDmrIdHint =>
      'Obtenez votre DMR ID gratuitement sur radioid.net';

  @override
  String get wizardRadioTitle => 'Votre radio';

  @override
  String get wizardRadioText =>
      'Sélectionnez le modèle de votre radio pour optimiser la configuration.';

  @override
  String get wizardFinishTitle => 'C\'est prêt !';

  @override
  String get wizardFinishText =>
      'Votre configuration est créée. Vous pouvez maintenant ajouter des canaux, zones et contacts.';

  @override
  String get wizardAddDefaultContacts =>
      'Ajouter les contacts par défaut (France, Europe, etc.)';

  @override
  String get wizardNext => 'Suivant';

  @override
  String get wizardBack => 'Retour';

  @override
  String get wizardFinish => 'Terminer';

  @override
  String get wizardSkip => 'Passer';

  @override
  String get importCsv => 'Importer CSV';

  @override
  String get exportCsv => 'Exporter CSV';

  @override
  String importSuccess(int count) {
    return '$count canaux importés';
  }

  @override
  String get exportSuccess => 'Export réussi';

  @override
  String get exportPdf => 'Exporter en PDF';

  @override
  String get importError => 'Erreur lors de l\'import';

  @override
  String get noChannelsToExport => 'Aucun canal à exporter';

  @override
  String get zoneChannels => 'Canaux de la zone';

  @override
  String get availableChannels => 'Canaux disponibles';

  @override
  String get addToZone => 'Ajouter à la zone';

  @override
  String get removeFromZone => 'Retirer de la zone';

  @override
  String get noChannelsInZone => 'Aucun canal dans cette zone';

  @override
  String get dragChannelsHint =>
      'Glissez des canaux ici ou utilisez le bouton +';

  @override
  String get manageChannels => 'Gérer les canaux';

  @override
  String get validate => 'Valider';

  @override
  String get validationTitle => 'Validation du codeplug';

  @override
  String get validationPassed => 'Validation réussie';

  @override
  String get validationPassedHint => 'Aucun problème détecté';

  @override
  String validationErrors(int count) {
    return '$count erreur(s)';
  }

  @override
  String validationWarnings(int count) {
    return '$count avertissement(s)';
  }

  @override
  String validationInfos(int count) {
    return '$count information(s)';
  }

  @override
  String get importQdmr => 'Importer qdmr (.yaml)';

  @override
  String importQdmrSuccess(String name) {
    return 'Codeplug importé : $name';
  }

  @override
  String get importQdmrError => 'Erreur lors de l\'import du fichier qdmr';
}
