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

  @override
  String get shopButton => 'Shop';

  @override
  String get shopTitle => 'Chigüi\'s shop';

  @override
  String get shopHint => 'What shall we get today?';

  @override
  String get seasonalSection => 'Seasonal';

  @override
  String get accessoriesSection => 'Accessories';

  @override
  String get stickersSection => 'Stickers';

  @override
  String get wearButton => 'Wear';

  @override
  String get takeOffButton => 'Take off';

  @override
  String get inAlbum => 'In your album';

  @override
  String get boughtStatus => 'New look unlocked!';

  @override
  String get stickerBoughtStatus => 'Sticker added to your album!';

  @override
  String notEnoughCoins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Error 402: $count coins missing. A few rounds of Fruit catch will fix it!',
      one: 'Error 402: 1 coin missing. One round of Fruit catch will fix it!',
    );
    return '$_temp0';
  }

  @override
  String get seasonSpooktober => 'Spooktober';

  @override
  String get seasonChristmas => 'Christmas';

  @override
  String get seasonSpring => 'Spring';

  @override
  String get seasonSummer => 'Summer';

  @override
  String get backSpooktober => 'Back every October';

  @override
  String get backChristmas => 'Back every Christmas';

  @override
  String get backSpring => 'Back every spring';

  @override
  String get backSummer => 'Back every summer';

  @override
  String get tooEarlySpooktober =>
      'The ghosts are still snoring in their crypt. Come back in October!';

  @override
  String get tooEarlyChristmas =>
      'Santa\'s elves are still compiling the presents. Come back in December!';

  @override
  String get tooEarlySpring =>
      'The flowers are still in beta. Come back in spring!';

  @override
  String get tooEarlySummer =>
      'The beach is still loading… 42%. Come back in summer!';

  @override
  String get itemGeekGlasses => 'Geek glasses';

  @override
  String get itemBeanie => 'Woolly hat';

  @override
  String get itemScarf => 'Scarf';

  @override
  String get itemHeadphones => 'Headphones';

  @override
  String get itemGhost => 'Ghost costume';

  @override
  String get itemPumpkin => 'Pumpkin';

  @override
  String get itemSantaHat => 'Santa hat';

  @override
  String get itemXmasTree => 'Christmas tree';

  @override
  String get itemFlowerCrown => 'Flower crown';

  @override
  String get itemButterfly => 'Butterfly friend';

  @override
  String get itemSurfboard => 'Surfboard';

  @override
  String get itemSnorkel => 'Diving mask and snorkel';

  @override
  String get itemStickerStar => 'Star sticker';

  @override
  String get itemStickerHeart => 'Heart sticker';

  @override
  String get itemStickerRocket => 'Rocket sticker';

  @override
  String get itemStickerGamepad => 'Gamepad sticker';

  @override
  String get itemStickerMusic => 'Music sticker';

  @override
  String get itemStickerIceCream => 'Ice cream sticker';
}
