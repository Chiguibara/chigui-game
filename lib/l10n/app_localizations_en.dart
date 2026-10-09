// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Chigüi';

  @override
  String get chiguiName => 'Chigüi';

  @override
  String get tapHint => 'Tap Chigüi to say hi';

  @override
  String get petAction => 'pet Chigüi';

  @override
  String get lovedStatus => 'Chigüi is happy!';

  @override
  String get ateStatus => 'Yum! Thank you!';

  @override
  String get fullStatus => 'Chigüi has had enough for now';

  @override
  String get wantsFood => 'Chigüi could go for a snack';

  @override
  String get wantsAffection => 'Chigüi would love some cuddles';

  @override
  String get wantsFun => 'Chigüi feels like playing';

  @override
  String get feedButton => 'Feed';

  @override
  String get needFood => 'Food';

  @override
  String get needAffection => 'Affection';

  @override
  String get needFun => 'Fun';

  @override
  String needMeterLabel(String need, int percent) {
    return '$need: $percent%';
  }
}
