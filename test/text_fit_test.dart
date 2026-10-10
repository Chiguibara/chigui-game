import 'dart:io';
import 'dart:typed_data';

import 'package:chigui_game/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Checks, with the real Roboto font, that texts shown in fixed-size places
/// fit on a small phone (360×740) in every language. The default test font
/// draws blocks and would hide truncation.
void main() {
  const fonts = '/sdks/flutter/bin/cache/artifacts/material_fonts';

  Future<void> loadRoboto() async {
    Future<ByteData> font(String name) async =>
        ByteData.sublistView(File('$fonts/$name').readAsBytesSync());
    await (FontLoader('Roboto')
          ..addFont(font('Roboto-Regular.ttf'))
          ..addFont(font('Roboto-Medium.ttf'))
          ..addFont(font('Roboto-Bold.ttf')))
        .load();
  }

  // The phone frame on a 360×740 screen is 341 px wide.
  const frame = 341.0;

  bool fits(
    String text, {
    required double width,
    required int lines,
    required double size,
    FontWeight weight = FontWeight.w400,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: size,
          fontWeight: weight,
          height: 1.3,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: lines,
      textAlign: TextAlign.center,
    )..layout(maxWidth: width);
    return !painter.didExceedMaxLines;
  }

  for (final locale in AppLocalizations.supportedLocales) {
    testWidgets('texts fit on a small phone in ${locale.languageCode}', (
      tester,
    ) async {
      await tester.runAsync(loadRoboto);
      final l = lookupAppLocalizations(locale);
      final problems = <String>[];
      void check(
        String name,
        String text, {
        required double width,
        required int lines,
        required double size,
        FontWeight weight = FontWeight.w400,
      }) {
        if (!fits(
          text,
          width: width,
          lines: lines,
          size: size,
          weight: weight,
        )) {
          problems.add('$name: "$text"');
        }
      }

      // Home status line: two lines, 24 px padding each side.
      for (final (name, text) in [
        ('tapHint', l.tapHint),
        ('lovedStatus', l.lovedStatus),
        ('pettedLowStatus', l.pettedLowStatus),
        ('pettedMidStatus', l.pettedMidStatus),
        ('ateStatus', l.ateStatus),
        ('fullStatus', l.fullStatus),
        ('wantsFood', l.wantsFood),
        ('wantsAffection', l.wantsAffection),
        ('wantsFun', l.wantsFun),
        ('asleepStatus', l.asleepStatus),
        ('sickStatus', l.sickStatus),
        ('pottyStatus', l.pottyStatus),
        ('sleepyStatus', l.sleepyStatus),
        ('mealtimeStatus', l.mealtimeStatus),
        ('grumpyStatus', l.grumpyStatus),
        ('messStatus', l.messStatus),
        ('reliefStatus', l.reliefStatus),
        ('curedStatus', l.curedStatus),
        ('cleanedStatus', l.cleanedStatus),
        ('walkedStatus', l.walkedStatus),
      ]) {
        check(
          name,
          text,
          width: frame - 48,
          lines: 2,
          size: 16,
          weight: FontWeight.w500,
        );
      }

      // Shop message: three lines, 16 px padding each side.
      for (final (name, text) in [
        ('shopHint', l.shopHint),
        ('boughtStatus', l.boughtStatus),
        ('stickerBoughtStatus', l.stickerBoughtStatus),
        ('notEnoughCoins', l.notEnoughCoins(115)),
        ('tooEarlySpooktober', l.tooEarlySpooktober),
        ('tooEarlyChristmas', l.tooEarlyChristmas),
        ('tooEarlySpring', l.tooEarlySpring),
        ('tooEarlySummer', l.tooEarlySummer),
        ('packBoughtStatus', l.packBoughtStatus),
        ('packErrorStatus', l.packErrorStatus),
      ]) {
        check(name, text, width: frame - 32, lines: 3, size: 16);
      }

      // Home action tiles: four in a row, label up to two lines.
      final tile = (frame - 24 - 3 * 8) / 4 - 12;
      for (final (name, text) in [
        ('feedButton', l.feedButton),
        ('playButton', l.playButton),
        ('walkButton', l.walkButton),
        ('shopButton', l.shopButton),
      ]) {
        check(
          name,
          text,
          width: tile,
          lines: 2,
          size: 12,
          weight: FontWeight.w700,
        );
      }

      expect(problems, isEmpty);
    });
  }
}
