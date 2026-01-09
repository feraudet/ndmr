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
