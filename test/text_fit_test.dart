import 'dart:io';

import 'package:chigui_game/game/achievements.dart';
import 'package:chigui_game/game/catalog.dart';
import 'package:chigui_game/l10n/app_localizations.dart';
import 'package:chigui_game/shop/item_display.dart';
import 'package:chigui_game/ui/achievements_screen.dart';
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

  // A long name players might give Chigüi.
  const name = 'Bartolomeo';

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
        ('tapHint', l.tapHint(name)),
        ('lovedStatus', l.lovedStatus(name)),
        ('pettedLowStatus', l.pettedLowStatus(name)),
        ('pettedMidStatus', l.pettedMidStatus),
        ('ateStatus', l.ateStatus),
        ('fullStatus', l.fullStatus(name)),
        ('wantsFood', l.wantsFood(name)),
        ('wantsAffection', l.wantsAffection(name)),
        ('wantsFun', l.wantsFun(name)),
        ('asleepStatus', l.asleepStatus(name)),
        ('sickStatus', l.sickStatus(name)),
        ('pottyStatus', l.pottyStatus(name)),
        ('sleepyStatus', l.sleepyStatus(name)),
        ('mealtimeStatus', l.mealtimeStatus),
        ('yawnStatus', l.yawnStatus(name)),
        ('messStatus', l.messStatus),
        ('reliefStatus', l.reliefStatus),
        ('curedStatus', l.curedStatus),
        ('cleanedStatus', l.cleanedStatus),
        ('walkedStatus', l.walkedStatus),
        ('studyStatus', l.studyStatus),
        ('renamedStatus', l.renamedStatus(name)),
        ('schoolStatus', l.schoolStatus),
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

      // Hide-and-seek and bath statuses, and the game list's cards: two lines, large.
      for (final (name, text, width) in [
        ('hideWatch', l.hideWatch(name), frame - 32),
        ('hidePick', l.hidePick(name), frame - 32),
        ('hideFound', l.hideFound, frame - 32),
        ('hideMissed', l.hideMissed, frame - 32),
        ('minigameTitle', l.minigameTitle, 300 - 32 - 64 - 16.0),
        ('memoryTitle', l.memoryTitle, 300 - 32 - 64 - 16.0),
        ('hideTitle', l.hideTitle, 300 - 32 - 64 - 16.0),
        ('bathTitle', l.bathTitle, 300 - 32 - 64 - 16.0),
        ('mathTitle', l.mathTitle, 300 - 32 - 64 - 16.0),
        ('mathTryAgain', l.mathTryAgain, frame - 32),
        ('bathArrive', l.bathArrive(name), frame - 32),
        ('bathHopIn', l.bathHopIn(name), frame - 32),
        ('bathWash', l.bathWash, frame - 32),
        ('bathYuzu', l.bathYuzu, frame - 32),
        ('bathSoak', l.bathSoak, frame - 32),
        ('bathDry', l.bathDry(name), frame - 32),
        ('bathDone', l.bathDone, frame - 32),
      ]) {
        check(name, text, width: width, lines: 2, size: 22);
      }

      // Maths levels: one line, 14 px medium, beside up to four coins.
      for (final (name, text) in [
        ('mathLevelSums', l.mathLevelSums),
        ('mathLevelUpTo20', l.mathLevelUpTo20),
        ('mathLevelUpTo100', l.mathLevelUpTo100),
        ('mathLevelTables', l.mathLevelTables),
        ('mathLevelMultiplyDivide', l.mathLevelMultiplyDivide),
        ('mathLevelFractions', l.mathLevelFractions),
        ('mathLevelIntegers', l.mathLevelIntegers),
        ('mathLevelEquations', l.mathLevelEquations),
      ]) {
        check(
          name,
          text,
          width: 300 - 32 - 8 - 4 * 20.0,
          lines: 1,
          size: 14,
          weight: FontWeight.w500,
        );
      }

      // Album page titles, between the arrows, with "· 8/8": one line.
      for (final page in AlbumPage.values) {
        check(
          page.name,
          '${l.albumPageName(page)} · 8/8',
          width: 3 * 96 + 2 * 8 + 2 * 8 - 2 * 48,
          lines: 1,
          size: 16,
          weight: FontWeight.w700,
        );
      }

      // Sticker names under their album spots: two lines, 12 px.
      for (final item in stickers) {
        check(item.id, l.itemName(item), width: 96, lines: 2, size: 12);
      }

      // Achievement cards: the name on one line, beside the medal.
      for (final a in Achievement.values) {
        check(
          a.name,
          l.achievementName(a),
          width: 320 - 24 - 72 - 12,
          lines: 1,
          size: 16,
          weight: FontWeight.w700,
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

      // Album status line: two lines, 16 px padding each side.
      for (final (name, text) in [
        ('albumHint', l.albumHint),
        ('albumEmpty', l.albumEmpty),
        ('albumStuck', l.albumStuck),
        ('albumAllStuck', l.albumAllStuck),
        ('albumComplete', l.albumComplete),
        ('albumOtherPages', l.albumOtherPages),
      ]) {
        check(
          name,
          text,
          width: frame - 32,
          lines: 2,
          size: 16,
          weight: FontWeight.w500,
        );
      }

      // Home buttons with good news (new stickers, a new version on the
      // web): one line, with an icon.
      for (final (name, text) in [
        ('newStickersButton', l.newStickersButton),
        ('updateButton', l.updateButton),
      ]) {
        check(
          name,
          text,
          width: frame - 24 - 40 - 18 - 8,
          lines: 1,
          size: 14,
          weight: FontWeight.w500,
        );
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
