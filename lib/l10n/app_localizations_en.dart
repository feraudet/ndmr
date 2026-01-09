// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Ndmr';

  @override
  String get navDashboard => 'Home';

  @override
  String get navChannels => 'Channels';

  @override
  String get navZones => 'Zones';

  @override
  String get navContacts => 'Contacts';

  @override
  String get navScanLists => 'Scan Lists';

  @override
  String get navSettings => 'Settings';

  @override
  String get welcomeTitle => 'Welcome to Ndmr';

  @override
  String get welcomeSubtitle => 'Create or open a configuration to get started';

  @override
  String get newConfig => 'New Configuration';

  @override
  String get openFile => 'Open File';

  @override
  String get saveFile => 'Save';

  @override
  String get configName => 'New Configuration';

  @override
  String get channels => 'Channels';

  @override
  String get channelsEmpty => 'No channels';

  @override
  String get channelsEmptyHint => 'Add your first channel to get started';

  @override
  String get addChannel => 'Add Channel';

  @override
  String get editChannel => 'Edit Channel';

  @override
  String get duplicateChannel => 'Duplicate Channel';

  @override
  String get deleteChannel => 'Delete Channel';

  @override
  String deleteChannelConfirm(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get zones => 'Zones';

  @override
  String get zonesEmpty => 'No zones';

  @override
  String get zonesEmptyHint => 'Zones help you organize your channels';

  @override
  String get addZone => 'Add Zone';

  @override
  String get editZone => 'Edit Zone';

  @override
  String get duplicateZone => 'Duplicate Zone';

  @override
  String get deleteZone => 'Delete Zone';

  @override
  String zoneChannelCount(int count) {
    return '$count channels';
  }

  @override
  String get contacts => 'Contacts';

  @override
  String get contactsEmpty => 'No contacts';

  @override
  String get contactsEmptyHint => 'Add talk groups and private contacts';

  @override
  String get addContact => 'Add Contact';

  @override
  String get editContact => 'Edit Contact';

  @override
  String get duplicateContact => 'Duplicate Contact';

  @override
  String get deleteContact => 'Delete Contact';

  @override
  String get settings => 'Settings';

  @override
  String get settingsIdentity => 'Identity';

  @override
  String get settingsDisplay => 'Display';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get statsDigitalChannels => 'Digital';

  @override
  String get statsAnalogChannels => 'Analog';

  @override
  String get statsTalkGroups => 'Talk Groups';

  @override
  String get statsPrivateContacts => 'Private';

  @override
  String get settingsSaved => 'Settings saved';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldRxFrequency => 'RX Frequency (MHz)';

  @override
  String get fieldTxFrequency => 'TX Frequency (MHz)';

  @override
  String get fieldMode => 'Mode';

  @override
  String get fieldPower => 'Power';

  @override
  String get fieldTimeslot => 'Timeslot';

  @override
  String get fieldColorCode => 'Color Code';

  @override
  String get fieldDmrId => 'DMR ID';

  @override
  String get fieldCallsign => 'Callsign';

  @override
  String get fieldIntroLine1 => 'Intro Line 1';

  @override
  String get fieldIntroLine2 => 'Intro Line 2';

  @override
  String get fieldCallType => 'Call Type';

  @override
  String get modeAnalog => 'ANALOG';

  @override
  String get modeDigital => 'DIGITAL';

  @override
  String get powerLow => 'LOW';

  @override
  String get powerMedium => 'MEDIUM';

  @override
  String get powerHigh => 'HIGH';

  @override
  String get powerTurbo => 'TURBO';

  @override
  String get callTypeGroup => 'GROUP';

  @override
  String get callTypePrivate => 'PRIVATE';

  @override
  String get callTypeAllCall => 'ALL CALL';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get fieldRequired => 'Required';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get outOfRange => 'Out of range';

  @override
  String get noConfigLoaded => 'No configuration loaded';

  @override
  String get noConfigToSave => 'No configuration to save';

  @override
  String configLoaded(String name) {
    return 'Loaded \"$name\"';
  }

  @override
  String get configSaved => 'Configuration saved';

  @override
  String get helpChannel =>
      'A channel is a pre-saved frequency, like a favorite radio station. It contains all the settings needed to communicate.';

  @override
  String get helpZone =>
      'A zone is a folder to organize your channels. For example: \'Local Repeaters\', \'Home Hotspot\', \'Simplex\'.';

  @override
  String get helpContact =>
      'A contact is a talk group or a person. Think of it like a Discord channel or a phone number.';

  @override
  String get helpTimeslot =>
      'DMR splits each frequency into 2 time slots (TS1 and TS2). Each repeater uses a specific timeslot for each talk group.';

  @override
  String get helpColorCode =>
      'The Color Code (0-15) is like an access code for the repeater. You must use the same one configured on the repeater.';

  @override
  String get helpDmrId =>
      'Your DMR ID is a unique 7-digit identifier. Get one free at radioid.net with your amateur radio license.';

  @override
  String get helpCallsign =>
      'Your official amateur radio callsign (e.g., W1ABC).';

  @override
  String get helpRxFrequency => 'Receive frequency: the one you listen on.';

  @override
  String get helpTxFrequency =>
      'Transmit frequency: the one you transmit on. Often different on repeaters.';

  @override
  String get helpPower =>
      'Transmit power. Use the minimum power needed to save battery.';

  @override
  String get helpTalkGroup =>
      'A Talk Group is a discussion group. TG 91 connects worldwide, TG 9 is local to the repeater.';

  @override
  String get searchChannelsHint => 'Search by name or frequency...';

  @override
  String get searchContactsHint => 'Search by name or DMR ID...';

  @override
  String get noResults => 'No results';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get unnamed => '(unnamed)';

  @override
  String get wizardTitle => 'Welcome to Ndmr';

  @override
  String get wizardWelcomeTitle => 'Set up your DMR radio';

  @override
  String get wizardWelcomeText =>
      'Ndmr makes it easy to program your DMR radio.\n\nThis guide will help you set up the basic information.';

  @override
  String get wizardIdentityTitle => 'Your identity';

  @override
  String get wizardIdentityText =>
      'This information identifies you on the global DMR network.';

  @override
  String get wizardDmrIdHint => 'Get your DMR ID for free at radioid.net';

  @override
  String get wizardRadioTitle => 'Your radio';

  @override
  String get wizardRadioText =>
      'Select your radio model to optimize the configuration.';

  @override
  String get wizardFinishTitle => 'You\'re all set!';

  @override
  String get wizardFinishText =>
      'Your configuration is ready. You can now add channels, zones, and contacts.';

  @override
  String get wizardAddDefaultContacts =>
      'Add default contacts (Worldwide, Europe, etc.)';

  @override
  String get wizardNext => 'Next';

  @override
  String get wizardBack => 'Back';

  @override
  String get wizardFinish => 'Finish';

  @override
  String get wizardSkip => 'Skip';

  @override
  String get importCsv => 'Import CSV';

  @override
  String get exportCsv => 'Export CSV';

  @override
  String importSuccess(int count) {
    return '$count channels imported';
  }

  @override
  String get exportSuccess => 'Export successful';

  @override
  String get exportPdf => 'Export PDF';

  @override
  String get importError => 'Import error';

  @override
  String get noChannelsToExport => 'No channels to export';

  @override
  String get zoneChannels => 'Zone channels';

  @override
  String get availableChannels => 'Available channels';

  @override
  String get addToZone => 'Add to zone';

  @override
  String get removeFromZone => 'Remove from zone';

  @override
  String get noChannelsInZone => 'No channels in this zone';

  @override
  String get dragChannelsHint => 'Drag channels here or use the + button';

  @override
  String get manageChannels => 'Manage channels';

  @override
  String get validate => 'Validate';

  @override
  String get validationTitle => 'Codeplug validation';

  @override
  String get validationPassed => 'Validation passed';

  @override
  String get validationPassedHint => 'No issues detected';

  @override
  String validationErrors(int count) {
    return '$count error(s)';
  }

  @override
  String validationWarnings(int count) {
    return '$count warning(s)';
  }

  @override
  String validationInfos(int count) {
    return '$count info(s)';
  }

  @override
  String get importQdmr => 'Import qdmr (.yaml)';

  @override
  String importQdmrSuccess(String name) {
    return 'Codeplug imported: $name';
  }

  @override
  String get importQdmrError => 'Error importing qdmr file';

  @override
  String get scanLists => 'Scan Lists';

  @override
  String get scanListsEmpty => 'No scan lists';

  @override
  String get scanListsEmptyHint =>
      'Scan lists let your radio scan multiple channels';

  @override
  String get addScanList => 'Add Scan List';

  @override
  String get editScanList => 'Edit Scan List';

  @override
  String get duplicateScanList => 'Duplicate Scan List';

  @override
  String get deleteScanList => 'Delete Scan List';

  @override
  String scanListChannelCount(int count) {
    return '$count channels';
  }

  @override
  String get scanListChannels => 'Scan list channels';

  @override
  String get noChannelsInScanList => 'No channels in this scan list';

  @override
  String get addToScanList => 'Add to scan list';

  @override
  String get removeFromScanList => 'Remove from scan list';

  @override
  String get allChannelsAdded => 'All channels added';

  @override
  String get priorityChannel => 'Priority';

  @override
  String get setPriorityChannel => 'Set as priority channel';

  @override
  String get helpScanList =>
      'A scan list is a group of channels your radio will cycle through to find activity. You can set a priority channel that will be checked more frequently.';

  @override
  String get repeaterbookTitle => 'Import from Repeaterbook';

  @override
  String get repeaterbookSubtitle =>
      'Search for DMR repeaters and import them as channels';

  @override
  String get repeaterbookCountry => 'Country';

  @override
  String get repeaterbookCity => 'City (optional)';

  @override
  String get repeaterbookCityHint => 'Filter by city';

  @override
  String get repeaterbookSearch => 'Search';

  @override
  String get repeaterbookImport => 'Import';

  @override
  String get repeaterbookHint =>
      'Select a country and search for DMR repeaters';

  @override
  String repeaterbookSelected(int selected, int total) {
    return '$selected of $total selected';
  }

  @override
  String get repeaterbookSelectAll => 'Select all';

  @override
  String get repeaterbookDeselectAll => 'Deselect all';

  @override
  String repeaterbookSuccess(int count) {
    return '$count repeaters imported';
  }

  @override
  String get repeaterbookNoConfig => 'Create a configuration first';
}
