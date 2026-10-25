import 'package:flutter/material.dart';

import '../game/pet_controller.dart';
import '../game/rules.dart' show maxPetNameLength;
import '../l10n/app_localizations.dart';
import 'palette.dart';
import 'pet_name.dart';

/// Asks for a new name for Chigüi; true when the name was changed. A new
/// game's first name is free, then the name can change once a month.
Future<bool> showRenameDialog(BuildContext context, PetController pet) async =>
    await showDialog<bool>(
      context: context,
      builder: (_) => _RenameDialog(pet: pet),
    ) ??
    false;

class _RenameDialog extends StatefulWidget {
  const _RenameDialog({required this.pet});

  final PetController pet;

  @override
  State<_RenameDialog> createState() => _RenameDialogState();
}

class _RenameDialogState extends State<_RenameDialog> {
  late final _field = TextEditingController(text: widget.pet.state.name);

  @override
  void dispose() {
    _field.dispose();
    super.dispose();
  }

  void _save() {
    final renamed = widget.pet.rename(_field.text);
    if (renamed) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;
    final state = widget.pet.state;
    final open = widget.pet.canRename;
    final button = FilledButton.styleFrom(
      backgroundColor: Palette.ink,
      foregroundColor: Palette.mint,
      minimumSize: const Size(64, 48),
    );
    return AlertDialog(
      title: Text(l10n.renameTitle(l10n.petName(state))),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (open)
              TextField(
                controller: _field,
                autofocus: true,
                maxLength: maxPetNameLength,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _save(),
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(labelText: l10n.renameField),
              ),
            Text(
              !open
                  ? l10n.renameWait
                  : state.freeRename
                  ? l10n.renameFirstFree
                  : l10n.renameMonthly,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      actions: [
        if (open) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: Palette.ink,
              minimumSize: const Size(64, 48),
            ),
            child: Text(l10n.renameCancel),
          ),
          FilledButton(
            onPressed: _field.text.trim().isEmpty ? null : _save,
            style: button,
            child: Text(l10n.renameSave),
          ),
        ] else
          FilledButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: button,
            child: Text(l10n.achievementOk),
          ),
      ],
    );
  }
}
