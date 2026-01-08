import '../models/models.dart';

enum ValidationSeverity { error, warning, info }

class ValidationIssue {
  const ValidationIssue({
    required this.severity,
    required this.message,
    this.itemId,
    this.itemType,
  });

  final ValidationSeverity severity;
  final String message;
  final String? itemId;
  final String? itemType;
}

class ValidationResult {
  const ValidationResult(this.issues);

  final List<ValidationIssue> issues;

  bool get isValid => !issues.any((i) => i.severity == ValidationSeverity.error);

  int get errorCount =>
      issues.where((i) => i.severity == ValidationSeverity.error).length;

  int get warningCount =>
      issues.where((i) => i.severity == ValidationSeverity.warning).length;

  int get infoCount =>
      issues.where((i) => i.severity == ValidationSeverity.info).length;
}

class ValidationService {
  ValidationResult validate(Codeplug codeplug) {
    final issues = <ValidationIssue>[];

    // Validate settings
    _validateSettings(codeplug.settings, issues);

    // Validate channels
    for (final channel in codeplug.channels) {
      _validateChannel(channel, issues);
    }

    // Validate zones
    for (final zone in codeplug.zones) {
      _validateZone(zone, codeplug.channels, issues);
    }

    // Validate contacts
    for (final contact in codeplug.contacts) {
      _validateContact(contact, issues);
    }

    // Check for empty codeplug
    if (codeplug.channels.isEmpty) {
      issues.add(const ValidationIssue(
        severity: ValidationSeverity.warning,
        message: 'No channels defined',
      ));
    }

    return ValidationResult(issues);
  }

  void _validateSettings(RadioSettings settings, List<ValidationIssue> issues) {
    if (settings.dmrId == 0) {
      issues.add(const ValidationIssue(
        severity: ValidationSeverity.error,
        message: 'DMR ID is not set',
        itemType: 'settings',
      ));
    } else if (settings.dmrId < 1000000 || settings.dmrId > 9999999) {
      issues.add(ValidationIssue(
        severity: ValidationSeverity.warning,
        message: 'DMR ID ${settings.dmrId} seems invalid (should be 7 digits)',
        itemType: 'settings',
      ));
    }

    if (settings.callsign.isEmpty) {
      issues.add(const ValidationIssue(
        severity: ValidationSeverity.warning,
        message: 'Callsign is not set',
        itemType: 'settings',
      ));
    }
  }

  void _validateChannel(Channel channel, List<ValidationIssue> issues) {
    if (channel.name.isEmpty) {
      issues.add(ValidationIssue(
        severity: ValidationSeverity.warning,
        message: 'Channel has no name (${channel.rxFrequency} MHz)',
        itemId: channel.id,
        itemType: 'channel',
      ));
    }

    // Validate frequencies (amateur bands)
    if (!_isValidFrequency(channel.rxFrequency)) {
      issues.add(ValidationIssue(
        severity: ValidationSeverity.warning,
        message: 'RX frequency ${channel.rxFrequency} MHz is outside amateur bands',
        itemId: channel.id,
        itemType: 'channel',
      ));
    }

    if (!_isValidFrequency(channel.txFrequency)) {
      issues.add(ValidationIssue(
        severity: ValidationSeverity.warning,
        message: 'TX frequency ${channel.txFrequency} MHz is outside amateur bands',
        itemId: channel.id,
        itemType: 'channel',
      ));
    }

    // DMR specific validations
    if (channel.mode == ChannelMode.digital) {
      if (channel.timeslot < 1 || channel.timeslot > 2) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          message: 'Invalid timeslot ${channel.timeslot} for channel ${channel.name}',
          itemId: channel.id,
          itemType: 'channel',
        ));
      }

      if (channel.colorCode < 0 || channel.colorCode > 15) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          message: 'Invalid color code ${channel.colorCode} for channel ${channel.name}',
          itemId: channel.id,
          itemType: 'channel',
        ));
      }
    }
  }

  void _validateZone(Zone zone, List<Channel> channels, List<ValidationIssue> issues) {
    if (zone.name.isEmpty) {
      issues.add(ValidationIssue(
        severity: ValidationSeverity.warning,
        message: 'Zone has no name',
        itemId: zone.id,
        itemType: 'zone',
      ));
    }

    // Check for invalid channel references
    for (final channelId in zone.channelIds) {
      if (!channels.any((c) => c.id == channelId)) {
        issues.add(ValidationIssue(
          severity: ValidationSeverity.error,
          message: 'Zone "${zone.name}" references non-existent channel',
          itemId: zone.id,
          itemType: 'zone',
        ));
      }
    }

    if (zone.channelIds.isEmpty) {
      issues.add(ValidationIssue(
        severity: ValidationSeverity.info,
        message: 'Zone "${zone.name}" has no channels',
        itemId: zone.id,
        itemType: 'zone',
      ));
    }
  }

  void _validateContact(Contact contact, List<ValidationIssue> issues) {
    if (contact.name.isEmpty) {
      issues.add(ValidationIssue(
        severity: ValidationSeverity.warning,
        message: 'Contact has no name (ID: ${contact.dmrId})',
        itemId: contact.id,
        itemType: 'contact',
      ));
    }

    if (contact.dmrId <= 0) {
      issues.add(ValidationIssue(
        severity: ValidationSeverity.error,
        message: 'Contact "${contact.name}" has invalid DMR ID',
        itemId: contact.id,
        itemType: 'contact',
      ));
    }
  }

  bool _isValidFrequency(double freq) {
    // Common amateur radio bands
    // 2m band: 144-148 MHz
    // 70cm band: 430-440 MHz (EU) or 420-450 MHz (US)
    // 23cm band: 1240-1300 MHz

    return (freq >= 144 && freq <= 148) ||
           (freq >= 420 && freq <= 450) ||
           (freq >= 1240 && freq <= 1300) ||
           // Also allow PMR446 frequencies
           (freq >= 446 && freq <= 447);
  }
}
