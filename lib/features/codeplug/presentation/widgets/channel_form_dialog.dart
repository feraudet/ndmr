import 'package:flutter/material.dart';

import '../../data/models/models.dart';

class ChannelFormDialog extends StatefulWidget {
  const ChannelFormDialog({super.key, required this.channel});

  final Channel channel;

  @override
  State<ChannelFormDialog> createState() => _ChannelFormDialogState();
}

class _ChannelFormDialogState extends State<ChannelFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _rxFreqController;
  late TextEditingController _txFreqController;
  late ChannelMode _mode;
  late Power _power;
  late int _timeslot;
  late int _colorCode;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.channel.name);
    _rxFreqController = TextEditingController(
      text: widget.channel.rxFrequency.toStringAsFixed(4),
    );
    _txFreqController = TextEditingController(
      text: widget.channel.txFrequency.toStringAsFixed(4),
    );
    _mode = widget.channel.mode;
    _power = widget.channel.power;
    _timeslot = widget.channel.timeslot;
    _colorCode = widget.channel.colorCode;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rxFreqController.dispose();
    _txFreqController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.channel.name.isEmpty ? 'Add Channel' : 'Edit Channel'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Name required' : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _rxFreqController,
                          decoration:
                              const InputDecoration(labelText: 'RX Frequency (MHz)'),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            final val = double.tryParse(v);
                            if (val == null) return 'Invalid number';
                            if (val < 100 || val > 500) return 'Out of range';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextFormField(
                          controller: _txFreqController,
                          decoration:
                              const InputDecoration(labelText: 'TX Frequency (MHz)'),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            final val = double.tryParse(v);
                            if (val == null) return 'Invalid number';
                            if (val < 100 || val > 500) return 'Out of range';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<ChannelMode>(
                    value: _mode,
                    decoration: const InputDecoration(labelText: 'Mode'),
                    items: ChannelMode.values
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(m.name.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _mode = v ?? _mode),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Power>(
                    value: _power,
                    decoration: const InputDecoration(labelText: 'Power'),
                    items: Power.values
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _power = v ?? _power),
                  ),
                  if (_mode == ChannelMode.digital) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _timeslot,
                            decoration:
                                const InputDecoration(labelText: 'Timeslot'),
                            items: [1, 2]
                                .map((t) => DropdownMenuItem(
                                      value: t,
                                      child: Text('TS $t'),
                                    ))
                                .toList(),
                            onChanged: (v) =>
                                setState(() => _timeslot = v ?? _timeslot),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _colorCode,
                            decoration:
                                const InputDecoration(labelText: 'Color Code'),
                            items: List.generate(
                              16,
                              (i) => DropdownMenuItem(
                                value: i,
                                child: Text('CC $i'),
                              ),
                            ),
                            onChanged: (v) =>
                                setState(() => _colorCode = v ?? _colorCode),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      );

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final channel = widget.channel.copyWith(
      name: _nameController.text,
      rxFrequency: double.parse(_rxFreqController.text),
      txFrequency: double.parse(_txFreqController.text),
      mode: _mode,
      power: _power,
      timeslot: _timeslot,
      colorCode: _colorCode,
    );

    Navigator.pop(context, channel);
  }
}
