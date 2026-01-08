import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/help_tooltip.dart';
import '../providers/codeplug_provider.dart';

class SetupWizard extends ConsumerStatefulWidget {
  const SetupWizard({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  ConsumerState<SetupWizard> createState() => _SetupWizardState();
}

class _SetupWizardState extends ConsumerState<SetupWizard> {
  int _currentStep = 0;
  final _dmrIdController = TextEditingController();
  final _callsignController = TextEditingController();
  String _selectedRadio = 'Anytone AT-D878UV';
  bool _addDefaultContacts = true;

  static const _supportedRadios = [
    'Anytone AT-D878UV',
    'Anytone AT-D878UVII Plus',
    'Anytone AT-D578UV',
  ];

  @override
  void dispose() {
    _dmrIdController.dispose();
    _callsignController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wizardTitle),
        actions: [
          TextButton(
            onPressed: _skipWizard,
            child: Text(l10n.wizardSkip),
          ),
        ],
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        controlsBuilder: _buildControls,
        steps: [
          _buildWelcomeStep(l10n),
          _buildIdentityStep(l10n),
          _buildRadioStep(l10n),
          _buildFinishStep(l10n),
        ],
      ),
    );
  }

  Step _buildWelcomeStep(L10n l10n) => Step(
        title: Text(l10n.wizardWelcomeTitle),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.radio,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.wizardWelcomeText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      );

  Step _buildIdentityStep(L10n l10n) => Step(
        title: Text(l10n.wizardIdentityTitle),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.wizardIdentityText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dmrIdController,
                      decoration: InputDecoration(
                        labelText: l10n.fieldDmrId,
                        border: const OutlineInputBorder(),
                        helperText: l10n.wizardDmrIdHint,
                        helperMaxLines: 2,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  HelpTooltip(message: l10n.helpDmrId),
                ],
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => launchUrl(Uri.parse('https://radioid.net')),
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('radioid.net'),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _callsignController,
                      decoration: InputDecoration(
                        labelText: l10n.fieldCallsign,
                        border: const OutlineInputBorder(),
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                  HelpTooltip(message: l10n.helpCallsign),
                ],
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      );

  Step _buildRadioStep(L10n l10n) => Step(
        title: Text(l10n.wizardRadioTitle),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.wizardRadioText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ..._supportedRadios.map(
                (radio) => RadioListTile<String>(
                  title: Text(radio),
                  value: radio,
                  groupValue: _selectedRadio,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedRadio = value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      );

  Step _buildFinishStep(L10n l10n) => Step(
        title: Text(l10n.wizardFinishTitle),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.check_circle,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.wizardFinishText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              CheckboxListTile(
                value: _addDefaultContacts,
                onChanged: (value) {
                  setState(() => _addDefaultContacts = value ?? true);
                },
                title: Text(l10n.wizardAddDefaultContacts),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 3,
        state: StepState.indexed,
      );

  Widget _buildControls(BuildContext context, ControlsDetails details) {
    final l10n = L10n.of(context)!;
    final isLastStep = _currentStep == 3;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          FilledButton(
            onPressed: details.onStepContinue,
            child: Text(isLastStep ? l10n.wizardFinish : l10n.wizardNext),
          ),
          if (_currentStep > 0) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: details.onStepCancel,
              child: Text(l10n.wizardBack),
            ),
          ],
        ],
      ),
    );
  }

  void _onStepContinue() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _finishWizard();
    }
  }

  void _onStepCancel() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _skipWizard() {
    ref.read(codeplugNotifierProvider.notifier).createNew();
    widget.onComplete();
  }

  void _finishWizard() {
    final dmrId = int.tryParse(_dmrIdController.text) ?? 0;
    final callsign = _callsignController.text.toUpperCase();

    ref.read(codeplugNotifierProvider.notifier).createNew(
          radioModel: _selectedRadio,
          dmrId: dmrId,
          callsign: callsign,
          addDefaultContacts: _addDefaultContacts,
        );

    widget.onComplete();
  }
}
