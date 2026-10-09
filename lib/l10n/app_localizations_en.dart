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
  String get pettedLowStatus => 'Chigüi liked that! More cuddles, please?';

  @override
  String get pettedMidStatus => 'That feels nice! A little more?';

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

  @override
  String get toiletButton => 'Toilet';

  @override
  String get bedButton => 'Bedtime';

  @override
  String get vetButton => 'Vet';

  @override
  String get cleanAction => 'clean up';

  @override
  String get asleepStatus => 'Shh… Chigüi is sleeping';

  @override
  String get sickStatus => 'Chigüi doesn\'t feel well. Time for the vet!';

  @override
  String get pottyStatus => 'Chigüi needs the toilet!';

  @override
  String get sleepyStatus => 'Chigüi is sleepy';

  @override
  String get mealtimeStatus => 'It\'s mealtime!';

  @override
  String get grumpyStatus =>
      'Nobody sent Chigüi to bed, so Chigüi is a bit grumpy. A cuddle will help!';

  @override
  String get messStatus => 'Something smells… time to clean up!';

  @override
  String get reliefStatus => 'Phew, much better!';

  @override
  String get curedStatus => 'All better! So brave!';

  @override
  String get cleanedStatus => 'All clean!';

  @override
  String get playButton => 'Play';

  @override
  String coinsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count coins',
      one: '1 coin',
    );
    return '$_temp0';
  }

  @override
  String get minigameTitle => 'Fruit catch';

  @override
  String get minigameHint => 'Drag to move Chigüi and catch the fruit!';

  @override
  String get startButton => 'Start';

  @override
  String secondsLeft(int seconds) {
    return '$seconds s';
  }

  @override
  String fruitsCaught(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fruits caught',
      one: '1 fruit caught',
      zero: 'No fruit this time',
    );
    return '$_temp0';
  }

  @override
  String coinsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count coins',
      one: '+1 coin',
      zero: 'Chigüi had fun anyway!',
    );
    return '$_temp0';
  }

  @override
  String get roundDone => 'Great game!';

  @override
  String get playAgainButton => 'Play again';

  @override
  String get backHomeButton => 'Back home';

  @override
  String get chompSound => 'Chomp!';

  @override
  String get walkedStatus => 'What a lovely walk!';

  @override
  String stepsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps today',
      one: '1 step today',
    );
    return '$_temp0';
  }
}
