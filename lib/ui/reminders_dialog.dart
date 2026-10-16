import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../notify/reminders.dart';
import 'palette.dart';

/// The reminder settings: what they do, and a button to turn them on or
/// off. Turning them on asks the system for permission again if needed.
Future<void> showRemindersDialog(BuildContext context, Reminders reminders) =>
    showDialog<void>(
      context: context,
      builder: (_) => _RemindersDialog(reminders),
    );

class _RemindersDialog extends StatefulWidget {
  const _RemindersDialog(this.reminders);

  final Reminders reminders;

  @override
  State<_RemindersDialog> createState() => _RemindersDialogState();
}

class _RemindersDialogState extends State<_RemindersDialog> {
  bool _denied = false;

  Future<void> _turnOn() async {
    final on = await widget.reminders.turnOn();
    if (mounted) setState(() => _denied = !on);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reminders = widget.reminders;
    return ListenableBuilder(
      listenable: reminders,
      builder: (context, _) => AlertDialog(
        title: Text(l10n.remindersButton),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reminders.enabled ? l10n.remindersOnInfo : l10n.remindersOffInfo,
            ),
            if (_denied && !reminders.enabled) ...[
              const SizedBox(height: 12),
              Text(
                l10n.remindersDenied,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              // Android stops asking after two "no"s: the settings remain.
              TextButton.icon(
                onPressed: reminders.openSettings,
                icon: const Icon(Icons.settings),
                label: Text(l10n.remindersOpenSettings),
                style: TextButton.styleFrom(
                  foregroundColor: Palette.ink,
                  minimumSize: const Size(64, 48),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Palette.ink,
              minimumSize: const Size(64, 48),
            ),
            child: Text(MaterialLocalizations.of(context).closeButtonLabel),
          ),
          if (reminders.enabled)
            TextButton(
              onPressed: reminders.turnOff,
              style: TextButton.styleFrom(
                foregroundColor: Palette.ink,
                minimumSize: const Size(64, 48),
              ),
              child: Text(l10n.remindersTurnOff),
            )
          else
            FilledButton(
              onPressed: _turnOn,
              style: FilledButton.styleFrom(
                backgroundColor: Palette.ink,
                foregroundColor: Palette.mint,
                minimumSize: const Size(64, 48),
              ),
              child: Text(l10n.remindersTurnOn),
            ),
        ],
      ),
    );
  }
}
