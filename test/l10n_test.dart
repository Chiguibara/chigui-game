import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Every translation must have every text, with the same placeholders.
void main() {
  Map<String, dynamic> arb(String locale) =>
      jsonDecode(File('lib/l10n/app_$locale.arb').readAsStringSync())
          as Map<String, dynamic>;
  final english = arb('en');
  final keys = english.keys.where((k) => !k.startsWith('@')).toSet();
  final placeholder = RegExp(r'\{(\w+)[,}]');

  for (final locale in ['es', 'de', 'fr', 'ca']) {
    test('$locale has every text', () {
      final translation = arb(locale);
      final translated = translation.keys
          .where((k) => !k.startsWith('@'))
          .toSet();
      expect(translated, keys);
      for (final key in keys) {
        final expected = placeholder
            .allMatches(english[key] as String)
            .map((m) => m[1])
            .toSet();
        final actual = placeholder
            .allMatches(translation[key] as String)
            .map((m) => m[1])
            .toSet();
        expect(actual, expected, reason: '$locale: $key');
      }
    });
  }
}
