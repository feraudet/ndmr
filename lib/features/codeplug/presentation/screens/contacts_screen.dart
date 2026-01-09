import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/help_tooltip.dart';
import '../../data/models/models.dart';
import '../providers/codeplug_provider.dart';

const _uuid = Uuid();

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  CallType? _callTypeFilter;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() => _searchQuery = value);
    });
  }

  List<Contact> _filterContacts(List<Contact> contacts) {
    var filtered = contacts;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((c) {
        return c.name.toLowerCase().contains(query) ||
            c.dmrId.toString().contains(query);
      }).toList();
    }

    if (_callTypeFilter != null) {
      filtered = filtered.where((c) => c.callType == _callTypeFilter).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context)!;
    final codeplug = ref.watch(codeplugNotifierProvider);

    if (codeplug == null) {
      return Center(child: Text(l10n.noConfigLoaded));
    }

    final allContacts = codeplug.contacts;
    final filteredContacts = _filterContacts(allContacts);

    return Scaffold(
      body: Column(
        children: [
          // Search and filter bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: l10n.searchContactsHint,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 8),
                // Call type filter chips
                FilterChip(
                  label: Text(l10n.callTypeGroup),
                  selected: _callTypeFilter == CallType.group,
                  onSelected: (selected) {
                    setState(() {
                      _callTypeFilter = selected ? CallType.group : null;
                    });
                  },
                ),
                const SizedBox(width: 4),
                FilterChip(
                  label: Text(l10n.callTypePrivate),
                  selected: _callTypeFilter == CallType.private,
                  onSelected: (selected) {
                    setState(() {
                      _callTypeFilter = selected ? CallType.private : null;
                    });
                  },
                ),
              ],
            ),
          ),
          // Results count
          if (allContacts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${filteredContacts.length} / ${allContacts.length} ${l10n.contacts.toLowerCase()}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const Spacer(),
                  HelpTooltip(message: l10n.helpContact, iconSize: 16),
                ],
              ),
            ),
          const Divider(height: 1),
          // Contact list
          Expanded(
            child: allContacts.isEmpty
                ? _buildEmptyState(context, l10n)
                : filteredContacts.isEmpty
                    ? _buildNoResultsState(context, l10n)
                    : ListView.builder(
                        itemCount: filteredContacts.length,
                        itemBuilder: (context, index) {
                          final contact = filteredContacts[index];
                          return _ContactTile(
                            contact: contact,
                            l10n: l10n,
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        tooltip: l10n.addContact,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, L10n l10n) => Center(
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
              l10n.contactsEmpty,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(l10n.contactsEmptyHint),
          ],
        ),
      );

  Widget _buildNoResultsState(BuildContext context, L10n l10n) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noResults,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _callTypeFilter = null;
                });
              },
              child: Text(l10n.clearFilters),
            ),
          ],
        ),
      );

  Future<void> _showAddDialog(BuildContext context) async {
    final contact = await _showContactDialog(
      context,
      Contact(id: _uuid.v4(), name: '', dmrId: 0),
    );
    if (contact != null) {
      ref.read(codeplugNotifierProvider.notifier).addContact(contact);
    }
  }

  Future<Contact?> _showContactDialog(
    BuildContext context,
    Contact contact,
  ) async {
    final l10n = L10n.of(context)!;
    final nameController = TextEditingController(text: contact.name);
    final dmrIdController = TextEditingController(
      text: contact.dmrId == 0 ? '' : contact.dmrId.toString(),
    );
    var callType = contact.callType;

    return showDialog<Contact>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(contact.name.isEmpty ? l10n.addContact : l10n.editContact),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.fieldName),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dmrIdController,
                  decoration: InputDecoration(labelText: l10n.fieldDmrId),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CallType>(
                  value: callType,
                  decoration: InputDecoration(labelText: l10n.fieldCallType),
                  items: CallType.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(_callTypeLabel(l10n, t)),
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
              child: Text(l10n.cancel),
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
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }

  String _callTypeLabel(L10n l10n, CallType type) => switch (type) {
        CallType.group => l10n.callTypeGroup,
        CallType.private => l10n.callTypePrivate,
        CallType.allCall => l10n.callTypeAllCall,
      };
}

class _ContactTile extends ConsumerWidget {
  const _ContactTile({
    required this.contact,
    required this.l10n,
  });

  final Contact contact;
  final L10n l10n;

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

  String _callTypeLabel(CallType type) => switch (type) {
        CallType.group => l10n.callTypeGroup,
        CallType.private => l10n.callTypePrivate,
        CallType.allCall => l10n.callTypeAllCall,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListTile(
        leading: CircleAvatar(
          backgroundColor: _colorForCallType(contact.callType),
          child: Icon(
            _iconForCallType(contact.callType),
            color: Colors.white,
          ),
        ),
        title: Text(contact.name),
        subtitle: Text('${_callTypeLabel(contact.callType)} - ${contact.dmrId}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: l10n.editContact,
              onPressed: () => _showEditDialog(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.copy),
              tooltip: l10n.duplicateContact,
              onPressed: () => _duplicateContact(ref),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: l10n.deleteContact,
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      );

  void _duplicateContact(WidgetRef ref) {
    final duplicate = contact.copyWith(
      id: _uuid.v4(),
      name: '${contact.name} (copy)',
    );
    ref.read(codeplugNotifierProvider.notifier).addContact(duplicate);
  }

  Future<void> _showEditDialog(BuildContext context, WidgetRef ref) async {
    final nameController = TextEditingController(text: contact.name);
    final dmrIdController = TextEditingController(
      text: contact.dmrId.toString(),
    );
    var callType = contact.callType;

    final updated = await showDialog<Contact>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.editContact),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: l10n.fieldName),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: dmrIdController,
                  decoration: InputDecoration(labelText: l10n.fieldDmrId),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<CallType>(
                  value: callType,
                  decoration: InputDecoration(labelText: l10n.fieldCallType),
                  items: CallType.values
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(_callTypeLabel(t)),
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
              child: Text(l10n.cancel),
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
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );

    if (updated != null) {
      ref.read(codeplugNotifierProvider.notifier).updateContact(updated);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteContact),
        content: Text('${l10n.delete} "${contact.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      ref.read(codeplugNotifierProvider.notifier).deleteContact(contact.id);
    }
  }
}
