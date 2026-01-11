import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n? of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ndmr'**
  String get appTitle;

  /// No description provided for @navDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navDashboard;

  /// No description provided for @navChannels.
  ///
  /// In fr, this message translates to:
  /// **'Canaux'**
  String get navChannels;

  /// No description provided for @navZones.
  ///
  /// In fr, this message translates to:
  /// **'Zones'**
  String get navZones;

  /// No description provided for @navContacts.
  ///
  /// In fr, this message translates to:
  /// **'Contacts'**
  String get navContacts;

  /// No description provided for @navScanLists.
  ///
  /// In fr, this message translates to:
  /// **'Listes de balayage'**
  String get navScanLists;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get navSettings;

  /// No description provided for @welcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur Ndmr'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Créez ou ouvrez une configuration pour commencer'**
  String get welcomeSubtitle;

  /// No description provided for @newConfig.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle configuration'**
  String get newConfig;

  /// No description provided for @openFile.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir un fichier'**
  String get openFile;

  /// No description provided for @saveFile.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveFile;

  /// No description provided for @configName.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle configuration'**
  String get configName;

  /// No description provided for @channels.
  ///
  /// In fr, this message translates to:
  /// **'Canaux'**
  String get channels;

  /// No description provided for @channelsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun canal'**
  String get channelsEmpty;

  /// No description provided for @channelsEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre premier canal pour commencer'**
  String get channelsEmptyHint;

  /// No description provided for @addChannel.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un canal'**
  String get addChannel;

  /// No description provided for @editChannel.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le canal'**
  String get editChannel;

  /// No description provided for @duplicateChannel.
  ///
  /// In fr, this message translates to:
  /// **'Dupliquer le canal'**
  String get duplicateChannel;

  /// No description provided for @deleteChannel.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le canal'**
  String get deleteChannel;

  /// No description provided for @deleteChannelConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer \"{name}\" ?'**
  String deleteChannelConfirm(String name);

  /// No description provided for @zones.
  ///
  /// In fr, this message translates to:
  /// **'Zones'**
  String get zones;

  /// No description provided for @zonesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune zone'**
  String get zonesEmpty;

  /// No description provided for @zonesEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Les zones permettent d\'organiser vos canaux'**
  String get zonesEmptyHint;

  /// No description provided for @addZone.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une zone'**
  String get addZone;

  /// No description provided for @editZone.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la zone'**
  String get editZone;

  /// No description provided for @duplicateZone.
  ///
  /// In fr, this message translates to:
  /// **'Dupliquer la zone'**
  String get duplicateZone;

  /// No description provided for @deleteZone.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la zone'**
  String get deleteZone;

  /// No description provided for @zoneChannelCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} canaux'**
  String zoneChannelCount(int count);

  /// No description provided for @contacts.
  ///
  /// In fr, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @contactsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun contact'**
  String get contactsEmpty;

  /// No description provided for @contactsEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des groupes de discussion et contacts privés'**
  String get contactsEmptyHint;

  /// No description provided for @addContact.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un contact'**
  String get addContact;

  /// No description provided for @editContact.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le contact'**
  String get editContact;

  /// No description provided for @duplicateContact.
  ///
  /// In fr, this message translates to:
  /// **'Dupliquer le contact'**
  String get duplicateContact;

  /// No description provided for @deleteContact.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le contact'**
  String get deleteContact;

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get settings;

  /// No description provided for @settingsIdentity.
  ///
  /// In fr, this message translates to:
  /// **'Identité'**
  String get settingsIdentity;

  /// No description provided for @settingsDisplay.
  ///
  /// In fr, this message translates to:
  /// **'Affichage'**
  String get settingsDisplay;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get languageSystem;

  /// No description provided for @statsDigitalChannels.
  ///
  /// In fr, this message translates to:
  /// **'Numériques'**
  String get statsDigitalChannels;

  /// No description provided for @statsAnalogChannels.
  ///
  /// In fr, this message translates to:
  /// **'Analogiques'**
  String get statsAnalogChannels;

  /// No description provided for @statsTalkGroups.
  ///
  /// In fr, this message translates to:
  /// **'Talk Groups'**
  String get statsTalkGroups;

  /// No description provided for @statsPrivateContacts.
  ///
  /// In fr, this message translates to:
  /// **'Privés'**
  String get statsPrivateContacts;

  /// No description provided for @settingsSaved.
  ///
  /// In fr, this message translates to:
  /// **'Réglages enregistrés'**
  String get settingsSaved;

  /// No description provided for @fieldName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get fieldName;

  /// No description provided for @fieldRxFrequency.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence RX (MHz)'**
  String get fieldRxFrequency;

  /// No description provided for @fieldTxFrequency.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence TX (MHz)'**
  String get fieldTxFrequency;

  /// No description provided for @fieldMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode'**
  String get fieldMode;

  /// No description provided for @fieldPower.
  ///
  /// In fr, this message translates to:
  /// **'Puissance'**
  String get fieldPower;

  /// No description provided for @fieldTimeslot.
  ///
  /// In fr, this message translates to:
  /// **'Timeslot'**
  String get fieldTimeslot;

  /// No description provided for @fieldColorCode.
  ///
  /// In fr, this message translates to:
  /// **'Color Code'**
  String get fieldColorCode;

  /// No description provided for @fieldDmrId.
  ///
  /// In fr, this message translates to:
  /// **'DMR ID'**
  String get fieldDmrId;

  /// No description provided for @fieldCallsign.
  ///
  /// In fr, this message translates to:
  /// **'Indicatif'**
  String get fieldCallsign;

  /// No description provided for @fieldIntroLine1.
  ///
  /// In fr, this message translates to:
  /// **'Ligne d\'intro 1'**
  String get fieldIntroLine1;

  /// No description provided for @fieldIntroLine2.
  ///
  /// In fr, this message translates to:
  /// **'Ligne d\'intro 2'**
  String get fieldIntroLine2;

  /// No description provided for @fieldCallType.
  ///
  /// In fr, this message translates to:
  /// **'Type d\'appel'**
  String get fieldCallType;

  /// No description provided for @modeAnalog.
  ///
  /// In fr, this message translates to:
  /// **'ANALOGIQUE'**
  String get modeAnalog;

  /// No description provided for @modeDigital.
  ///
  /// In fr, this message translates to:
  /// **'NUMÉRIQUE'**
  String get modeDigital;

  /// No description provided for @powerLow.
  ///
  /// In fr, this message translates to:
  /// **'FAIBLE'**
  String get powerLow;

  /// No description provided for @powerMedium.
  ///
  /// In fr, this message translates to:
  /// **'MOYEN'**
  String get powerMedium;

  /// No description provided for @powerHigh.
  ///
  /// In fr, this message translates to:
  /// **'ÉLEVÉ'**
  String get powerHigh;

  /// No description provided for @powerTurbo.
  ///
  /// In fr, this message translates to:
  /// **'TURBO'**
  String get powerTurbo;

  /// No description provided for @callTypeGroup.
  ///
  /// In fr, this message translates to:
  /// **'GROUPE'**
  String get callTypeGroup;

  /// No description provided for @callTypePrivate.
  ///
  /// In fr, this message translates to:
  /// **'PRIVÉ'**
  String get callTypePrivate;

  /// No description provided for @callTypeAllCall.
  ///
  /// In fr, this message translates to:
  /// **'APPEL GÉNÉRAL'**
  String get callTypeAllCall;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @undo.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In fr, this message translates to:
  /// **'Rétablir'**
  String get redo;

  /// No description provided for @nameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le nom est requis'**
  String get nameRequired;

  /// No description provided for @fieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Requis'**
  String get fieldRequired;

  /// No description provided for @invalidNumber.
  ///
  /// In fr, this message translates to:
  /// **'Nombre invalide'**
  String get invalidNumber;

  /// No description provided for @outOfRange.
  ///
  /// In fr, this message translates to:
  /// **'Hors limites'**
  String get outOfRange;

  /// No description provided for @noConfigLoaded.
  ///
  /// In fr, this message translates to:
  /// **'Aucune configuration chargée'**
  String get noConfigLoaded;

  /// No description provided for @noConfigToSave.
  ///
  /// In fr, this message translates to:
  /// **'Aucune configuration à enregistrer'**
  String get noConfigToSave;

  /// No description provided for @configLoaded.
  ///
  /// In fr, this message translates to:
  /// **'Configuration \"{name}\" chargée'**
  String configLoaded(String name);

  /// No description provided for @configSaved.
  ///
  /// In fr, this message translates to:
  /// **'Configuration enregistrée'**
  String get configSaved;

  /// No description provided for @helpChannel.
  ///
  /// In fr, this message translates to:
  /// **'Un canal est une fréquence pré-enregistrée, comme une station de radio favorite. Il contient tous les paramètres nécessaires pour communiquer.'**
  String get helpChannel;

  /// No description provided for @helpZone.
  ///
  /// In fr, this message translates to:
  /// **'Une zone est un dossier pour organiser vos canaux. Par exemple : \'Relais locaux\', \'Hotspot maison\', \'Simplex\'.'**
  String get helpZone;

  /// No description provided for @helpContact.
  ///
  /// In fr, this message translates to:
  /// **'Un contact est un groupe de discussion (Talk Group) ou une personne. C\'est comme un salon Discord ou un numéro de téléphone.'**
  String get helpContact;

  /// No description provided for @helpTimeslot.
  ///
  /// In fr, this message translates to:
  /// **'Le DMR divise chaque fréquence en 2 créneaux temporels (TS1 et TS2). Chaque relais utilise un timeslot spécifique pour chaque talk group.'**
  String get helpTimeslot;

  /// No description provided for @helpColorCode.
  ///
  /// In fr, this message translates to:
  /// **'Le Color Code (0-15) est comme un code d\'accès au relais. Vous devez utiliser le même que celui configuré sur le relais.'**
  String get helpColorCode;

  /// No description provided for @helpDmrId.
  ///
  /// In fr, this message translates to:
  /// **'Votre DMR ID est un identifiant unique à 7 chiffres. Obtenez-le gratuitement sur radioid.net avec votre licence radioamateur.'**
  String get helpDmrId;

  /// No description provided for @helpCallsign.
  ///
  /// In fr, this message translates to:
  /// **'Votre indicatif radioamateur officiel (ex: F1TMV).'**
  String get helpCallsign;

  /// No description provided for @helpRxFrequency.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence de réception : celle sur laquelle vous écoutez.'**
  String get helpRxFrequency;

  /// No description provided for @helpTxFrequency.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence d\'émission : celle sur laquelle vous transmettez. Souvent différente sur les relais.'**
  String get helpTxFrequency;

  /// No description provided for @helpPower.
  ///
  /// In fr, this message translates to:
  /// **'Puissance d\'émission. Utilisez la puissance minimale nécessaire pour économiser la batterie.'**
  String get helpPower;

  /// No description provided for @helpTalkGroup.
  ///
  /// In fr, this message translates to:
  /// **'Un Talk Group est un groupe de discussion. Le TG 208 regroupe tous les radioamateurs français, le TG 9 est local au relais.'**
  String get helpTalkGroup;

  /// No description provided for @searchChannelsHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher par nom ou fréquence...'**
  String get searchChannelsHint;

  /// No description provided for @searchContactsHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher par nom ou DMR ID...'**
  String get searchContactsHint;

  /// No description provided for @noResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat'**
  String get noResults;

  /// No description provided for @clearFilters.
  ///
  /// In fr, this message translates to:
  /// **'Effacer les filtres'**
  String get clearFilters;

  /// No description provided for @unnamed.
  ///
  /// In fr, this message translates to:
  /// **'(sans nom)'**
  String get unnamed;

  /// No description provided for @wizardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur Ndmr'**
  String get wizardTitle;

  /// No description provided for @wizardWelcomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Configurez votre radio DMR'**
  String get wizardWelcomeTitle;

  /// No description provided for @wizardWelcomeText.
  ///
  /// In fr, this message translates to:
  /// **'Ndmr vous permet de programmer facilement votre radio DMR.\n\nCe guide va vous aider à configurer les informations de base.'**
  String get wizardWelcomeText;

  /// No description provided for @wizardIdentityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre identité'**
  String get wizardIdentityTitle;

  /// No description provided for @wizardIdentityText.
  ///
  /// In fr, this message translates to:
  /// **'Ces informations vous identifient sur le réseau DMR mondial.'**
  String get wizardIdentityText;

  /// No description provided for @wizardDmrIdHint.
  ///
  /// In fr, this message translates to:
  /// **'Obtenez votre DMR ID gratuitement sur radioid.net'**
  String get wizardDmrIdHint;

  /// No description provided for @wizardRadioTitle.
  ///
  /// In fr, this message translates to:
  /// **'Votre radio'**
  String get wizardRadioTitle;

  /// No description provided for @wizardRadioText.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez le modèle de votre radio pour optimiser la configuration.'**
  String get wizardRadioText;

  /// No description provided for @wizardFinishTitle.
  ///
  /// In fr, this message translates to:
  /// **'C\'est prêt !'**
  String get wizardFinishTitle;

  /// No description provided for @wizardFinishText.
  ///
  /// In fr, this message translates to:
  /// **'Votre configuration est créée. Vous pouvez maintenant ajouter des canaux, zones et contacts.'**
  String get wizardFinishText;

  /// No description provided for @wizardAddDefaultContacts.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter les contacts par défaut (France, Europe, etc.)'**
  String get wizardAddDefaultContacts;

  /// No description provided for @wizardNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get wizardNext;

  /// No description provided for @wizardBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get wizardBack;

  /// No description provided for @wizardFinish.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get wizardFinish;

  /// No description provided for @wizardSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get wizardSkip;

  /// No description provided for @importCsv.
  ///
  /// In fr, this message translates to:
  /// **'Importer CSV'**
  String get importCsv;

  /// No description provided for @exportCsv.
  ///
  /// In fr, this message translates to:
  /// **'Exporter CSV'**
  String get exportCsv;

  /// No description provided for @importSuccess.
  ///
  /// In fr, this message translates to:
  /// **'{count} canaux importés'**
  String importSuccess(int count);

  /// No description provided for @exportSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Export réussi'**
  String get exportSuccess;

  /// No description provided for @exportPdf.
  ///
  /// In fr, this message translates to:
  /// **'Exporter en PDF'**
  String get exportPdf;

  /// No description provided for @importError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'import'**
  String get importError;

  /// No description provided for @noChannelsToExport.
  ///
  /// In fr, this message translates to:
  /// **'Aucun canal à exporter'**
  String get noChannelsToExport;

  /// No description provided for @zoneChannels.
  ///
  /// In fr, this message translates to:
  /// **'Canaux de la zone'**
  String get zoneChannels;

  /// No description provided for @availableChannels.
  ///
  /// In fr, this message translates to:
  /// **'Canaux disponibles'**
  String get availableChannels;

  /// No description provided for @addToZone.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la zone'**
  String get addToZone;

  /// No description provided for @removeFromZone.
  ///
  /// In fr, this message translates to:
  /// **'Retirer de la zone'**
  String get removeFromZone;

  /// No description provided for @noChannelsInZone.
  ///
  /// In fr, this message translates to:
  /// **'Aucun canal dans cette zone'**
  String get noChannelsInZone;

  /// No description provided for @dragChannelsHint.
  ///
  /// In fr, this message translates to:
  /// **'Glissez des canaux ici ou utilisez le bouton +'**
  String get dragChannelsHint;

  /// No description provided for @manageChannels.
  ///
  /// In fr, this message translates to:
  /// **'Gérer les canaux'**
  String get manageChannels;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @validationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Validation du codeplug'**
  String get validationTitle;

  /// No description provided for @validationPassed.
  ///
  /// In fr, this message translates to:
  /// **'Validation réussie'**
  String get validationPassed;

  /// No description provided for @validationPassedHint.
  ///
  /// In fr, this message translates to:
  /// **'Aucun problème détecté'**
  String get validationPassedHint;

  /// No description provided for @validationErrors.
  ///
  /// In fr, this message translates to:
  /// **'{count} erreur(s)'**
  String validationErrors(int count);

  /// No description provided for @validationWarnings.
  ///
  /// In fr, this message translates to:
  /// **'{count} avertissement(s)'**
  String validationWarnings(int count);

  /// No description provided for @validationInfos.
  ///
  /// In fr, this message translates to:
  /// **'{count} information(s)'**
  String validationInfos(int count);

  /// No description provided for @importQdmr.
  ///
  /// In fr, this message translates to:
  /// **'Importer qdmr (.yaml)'**
  String get importQdmr;

  /// No description provided for @importQdmrSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Codeplug importé : {name}'**
  String importQdmrSuccess(String name);

  /// No description provided for @importQdmrError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors de l\'import du fichier qdmr'**
  String get importQdmrError;

  /// No description provided for @scanLists.
  ///
  /// In fr, this message translates to:
  /// **'Listes de balayage'**
  String get scanLists;

  /// No description provided for @scanListsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune liste de balayage'**
  String get scanListsEmpty;

  /// No description provided for @scanListsEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Les listes de balayage permettent de scanner plusieurs canaux'**
  String get scanListsEmptyHint;

  /// No description provided for @addScanList.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une liste'**
  String get addScanList;

  /// No description provided for @editScanList.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la liste'**
  String get editScanList;

  /// No description provided for @duplicateScanList.
  ///
  /// In fr, this message translates to:
  /// **'Dupliquer la liste'**
  String get duplicateScanList;

  /// No description provided for @deleteScanList.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la liste'**
  String get deleteScanList;

  /// No description provided for @scanListChannelCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} canaux'**
  String scanListChannelCount(int count);

  /// No description provided for @scanListChannels.
  ///
  /// In fr, this message translates to:
  /// **'Canaux de la liste'**
  String get scanListChannels;

  /// No description provided for @noChannelsInScanList.
  ///
  /// In fr, this message translates to:
  /// **'Aucun canal dans cette liste'**
  String get noChannelsInScanList;

  /// No description provided for @addToScanList.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter à la liste'**
  String get addToScanList;

  /// No description provided for @removeFromScanList.
  ///
  /// In fr, this message translates to:
  /// **'Retirer de la liste'**
  String get removeFromScanList;

  /// No description provided for @allChannelsAdded.
  ///
  /// In fr, this message translates to:
  /// **'Tous les canaux ajoutés'**
  String get allChannelsAdded;

  /// No description provided for @priorityChannel.
  ///
  /// In fr, this message translates to:
  /// **'Prioritaire'**
  String get priorityChannel;

  /// No description provided for @setPriorityChannel.
  ///
  /// In fr, this message translates to:
  /// **'Définir comme canal prioritaire'**
  String get setPriorityChannel;

  /// No description provided for @helpScanList.
  ///
  /// In fr, this message translates to:
  /// **'Une liste de balayage est un groupe de canaux que votre radio parcourt pour détecter l\'activité. Vous pouvez définir un canal prioritaire qui sera vérifié plus fréquemment.'**
  String get helpScanList;

  /// No description provided for @repeaterbookTitle.
  ///
  /// In fr, this message translates to:
  /// **'Importer depuis Repeaterbook'**
  String get repeaterbookTitle;

  /// No description provided for @repeaterbookSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherchez des relais DMR et importez-les comme canaux'**
  String get repeaterbookSubtitle;

  /// No description provided for @repeaterbookCountry.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get repeaterbookCountry;

  /// No description provided for @repeaterbookCity.
  ///
  /// In fr, this message translates to:
  /// **'Ville (optionnel)'**
  String get repeaterbookCity;

  /// No description provided for @repeaterbookCityHint.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par ville'**
  String get repeaterbookCityHint;

  /// No description provided for @repeaterbookSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get repeaterbookSearch;

  /// No description provided for @repeaterbookImport.
  ///
  /// In fr, this message translates to:
  /// **'Importer'**
  String get repeaterbookImport;

  /// No description provided for @repeaterbookHint.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez un pays et recherchez des relais DMR'**
  String get repeaterbookHint;

  /// No description provided for @repeaterbookSelected.
  ///
  /// In fr, this message translates to:
  /// **'{selected} sur {total} sélectionnés'**
  String repeaterbookSelected(int selected, int total);

  /// No description provided for @repeaterbookSelectAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout sélectionner'**
  String get repeaterbookSelectAll;

  /// No description provided for @repeaterbookDeselectAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout désélectionner'**
  String get repeaterbookDeselectAll;

  /// No description provided for @repeaterbookSuccess.
  ///
  /// In fr, this message translates to:
  /// **'{count} relais importés'**
  String repeaterbookSuccess(int count);

  /// No description provided for @repeaterbookNoConfig.
  ///
  /// In fr, this message translates to:
  /// **'Créez d\'abord une configuration'**
  String get repeaterbookNoConfig;

  /// No description provided for @unsavedChangesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifications non sauvegardées'**
  String get unsavedChangesTitle;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez des modifications non sauvegardées. Voulez-vous les sauvegarder avant de fermer ?'**
  String get unsavedChangesMessage;

  /// No description provided for @discardChanges.
  ///
  /// In fr, this message translates to:
  /// **'Abandonner'**
  String get discardChanges;

  /// No description provided for @saveAndClose.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder et fermer'**
  String get saveAndClose;

  /// No description provided for @dontClose.
  ///
  /// In fr, this message translates to:
  /// **'Ne pas fermer'**
  String get dontClose;

  /// No description provided for @navMap.
  ///
  /// In fr, this message translates to:
  /// **'Carte'**
  String get navMap;

  /// No description provided for @mapNoCodeplug.
  ///
  /// In fr, this message translates to:
  /// **'Aucune configuration chargée'**
  String get mapNoCodeplug;

  /// No description provided for @mapNoCodeplugHint.
  ///
  /// In fr, this message translates to:
  /// **'Créez ou ouvrez une configuration pour voir les relais sur la carte'**
  String get mapNoCodeplugHint;

  /// No description provided for @mapCountry.
  ///
  /// In fr, this message translates to:
  /// **'Pays :'**
  String get mapCountry;

  /// No description provided for @mapRepeaterCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} relais'**
  String mapRepeaterCount(int count);

  /// No description provided for @mapMyLocation.
  ///
  /// In fr, this message translates to:
  /// **'Ma position'**
  String get mapMyLocation;

  /// No description provided for @mapRefresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get mapRefresh;

  /// No description provided for @mapOnAir.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get mapOnAir;

  /// No description provided for @mapImportRepeater.
  ///
  /// In fr, this message translates to:
  /// **'Importer'**
  String get mapImportRepeater;

  /// No description provided for @repeaterImported.
  ///
  /// In fr, this message translates to:
  /// **'{name} importé comme canal'**
  String repeaterImported(String name);

  /// No description provided for @navCloud.
  ///
  /// In fr, this message translates to:
  /// **'Cloud'**
  String get navCloud;

  /// No description provided for @cloudSyncTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ndmr Cloud'**
  String get cloudSyncTitle;

  /// No description provided for @cloudSyncSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisez vos codeplugs sur tous vos appareils'**
  String get cloudSyncSubtitle;

  /// No description provided for @cloudLogin.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get cloudLogin;

  /// No description provided for @cloudRegister.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get cloudRegister;

  /// No description provided for @cloudLogout.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get cloudLogout;

  /// No description provided for @cloudEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get cloudEmail;

  /// No description provided for @cloudPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get cloudPassword;

  /// No description provided for @cloudInvalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse email invalide'**
  String get cloudInvalidEmail;

  /// No description provided for @cloudPasswordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 8 caractères'**
  String get cloudPasswordTooShort;

  /// No description provided for @cloudCallsignOptional.
  ///
  /// In fr, this message translates to:
  /// **'Optionnel - votre indicatif radioamateur'**
  String get cloudCallsignOptional;

  /// No description provided for @cloudNoAccount.
  ///
  /// In fr, this message translates to:
  /// **'Pas de compte ? Inscrivez-vous'**
  String get cloudNoAccount;

  /// No description provided for @cloudAlreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? Connectez-vous'**
  String get cloudAlreadyHaveAccount;

  /// No description provided for @cloudMyCodeplugs.
  ///
  /// In fr, this message translates to:
  /// **'Mes codeplugs'**
  String get cloudMyCodeplugs;

  /// No description provided for @cloudNoCodeplugs.
  ///
  /// In fr, this message translates to:
  /// **'Aucun codeplug dans le cloud'**
  String get cloudNoCodeplugs;

  /// No description provided for @cloudNoCodeplugsHint.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegardez un codeplug dans le cloud pour le synchroniser'**
  String get cloudNoCodeplugsHint;

  /// No description provided for @cloudSaveToCloud.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarder dans le cloud'**
  String get cloudSaveToCloud;

  /// No description provided for @cloudLoadFromCloud.
  ///
  /// In fr, this message translates to:
  /// **'Charger depuis le cloud'**
  String get cloudLoadFromCloud;

  /// No description provided for @cloudSyncing.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation...'**
  String get cloudSyncing;

  /// No description provided for @cloudSyncSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Synchronisation réussie'**
  String get cloudSyncSuccess;

  /// No description provided for @cloudSyncError.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la synchronisation'**
  String get cloudSyncError;

  /// No description provided for @cloudDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer du cloud'**
  String get cloudDelete;

  /// No description provided for @cloudDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer \"{name}\" du cloud ?'**
  String cloudDeleteConfirm(String name);

  /// No description provided for @cloudLastSync.
  ///
  /// In fr, this message translates to:
  /// **'Dernière sync : {date}'**
  String cloudLastSync(String date);

  /// No description provided for @cloudNotLoggedIn.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour synchroniser vos codeplugs'**
  String get cloudNotLoggedIn;

  /// No description provided for @cloudSignInToSync.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter pour synchroniser'**
  String get cloudSignInToSync;

  /// No description provided for @cloudOfflineMode.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes hors ligne. Les modifications seront synchronisées à la reconnexion.'**
  String get cloudOfflineMode;

  /// No description provided for @cloudSavedOffline.
  ///
  /// In fr, this message translates to:
  /// **'Enregistré localement. Synchronisation à la reconnexion.'**
  String get cloudSavedOffline;

  /// No description provided for @cloudPendingSync.
  ///
  /// In fr, this message translates to:
  /// **'{count} en attente'**
  String cloudPendingSync(int count);

  /// No description provided for @cloudPendingLabel.
  ///
  /// In fr, this message translates to:
  /// **'En attente de sync'**
  String get cloudPendingLabel;

  /// No description provided for @cloudSyncNow.
  ///
  /// In fr, this message translates to:
  /// **'Synchroniser'**
  String get cloudSyncNow;

  /// No description provided for @aboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get aboutTitle;

  /// No description provided for @aboutVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version {version}'**
  String aboutVersion(String version);

  /// No description provided for @aboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'Un éditeur de codeplug moderne pour radios DMR'**
  String get aboutDescription;

  /// No description provided for @aboutDeveloper.
  ///
  /// In fr, this message translates to:
  /// **'Développé par'**
  String get aboutDeveloper;

  /// No description provided for @aboutLicense.
  ///
  /// In fr, this message translates to:
  /// **'Licence'**
  String get aboutLicense;

  /// No description provided for @aboutOpenSource.
  ///
  /// In fr, this message translates to:
  /// **'Open Source'**
  String get aboutOpenSource;

  /// No description provided for @aboutWebsite.
  ///
  /// In fr, this message translates to:
  /// **'Site web'**
  String get aboutWebsite;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'fr':
      return L10nFr();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
