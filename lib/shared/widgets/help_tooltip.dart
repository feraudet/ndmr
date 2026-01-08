import 'package:flutter/material.dart';

/// A small info icon that shows a help tooltip when tapped or hovered.
class HelpTooltip extends StatelessWidget {
  const HelpTooltip({
    super.key,
    required this.message,
    this.iconSize = 18,
  });

  final String message;
  final double iconSize;

  @override
  Widget build(BuildContext context) => Tooltip(
        message: message,
        preferBelow: false,
        showDuration: const Duration(seconds: 10),
        triggerMode: TooltipTriggerMode.tap,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showHelpDialog(context),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Icon(
              Icons.help_outline,
              size: iconSize,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// A label with an integrated help tooltip.
class LabelWithHelp extends StatelessWidget {
  const LabelWithHelp({
    super.key,
    required this.label,
    required this.helpText,
  });

  final String label;
  final String helpText;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          HelpTooltip(message: helpText, iconSize: 16),
        ],
      );
}

/// An input decoration with a help tooltip suffix.
InputDecoration inputDecorationWithHelp({
  required String labelText,
  required String helpText,
  String? helperText,
}) =>
    InputDecoration(
      labelText: labelText,
      helperText: helperText,
      suffixIcon: HelpTooltip(message: helpText),
    );
