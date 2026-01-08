import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/models.dart';
import '../providers/codeplug_provider.dart';

const _uuid = Uuid();

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return const Center(child: Text('No codeplug loaded'));
    }

    final contacts = codeplug.contacts;

    return Scaffold(
      body: contacts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.contacts_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No contacts yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Add talk groups and private contacts'),
                ],
              ),
            )
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _colorForCallType(contact.callType),
                    child: Icon(
                      _iconForCallType(contact.callType),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(contact.name),
                  subtitle: Text('${contact.callType.name.toUpperCase()} - ${contact.dmrId}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(context, ref, contact),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDelete(context, ref, contact),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _colorForCallType(CallType type) => switch (type) {
        CallType.group => Colors.blue,
        CallType.private => Colors.green,
        CallType.allCall => Colors.orange,
      };

  IconData _iconForCallType(CallType type) => switch (type) {
        CallType.group => Icons.group,
        CallType.private => Icons.person,
        CallType.allCall => Icons.campaign,
      };

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final contact = await _showContactDialog(
      context,
      Contact(id: _uuid.v4(), name: '', dmrId: 0),
    );
    if (contact != null) {
      ref.read(codeplugNotifierProvider.notifier).addContact(contact);
    }
  }

  Future<void> _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    Contact contact,
  ) async {
    final updated = await _showContactDialog(context, contact);
    if (updated != null) {
      ref.read(codeplugNotifierProvider.notifier).updateContact(updated);
    }
  }

  Future<Contact?> _showContactDialog(
    BuildContext context,
    Contact contact,
  ) async {
    final nameController = TextEditingController(text: contact.name);
    final dmrIdController = TextEditingController(
      text: contact.dmrId == 0 ? '' : contact.dmrId.toString(),
    );
    var callType = contact.callType;

    return showDialog<Contact>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(contact.name.isEmpty ? 'Add Contact' : 'Edit Contact'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dmrIdController,
                  decoration: const InputDecoration(labelText: 'DMR ID'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CallType>(
                  value: callType,
                  decoration: const InputDecoration(labelText: 'Call Type'),
                  items: CallType.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.name.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => callType = v ?? callType),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final dmrId = int.tryParse(dmrIdController.text) ?? 0;
                if (nameController.text.isEmpty || dmrId == 0) return;
                Navigator.pop(
                  context,
                  contact.copyWith(
                    name: nameController.text,
                    dmrId: dmrId,
                    callType: callType,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Contact contact,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Delete "${contact.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(codeplugNotifierProvider.notifier).deleteContact(contact.id);
    }
  }
}
