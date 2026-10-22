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
  String get yawnStatus => 'Yaaawn… Chigüi woke up!';

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
  String get minigameHint =>
      'Drag to move Chigüi: catch the fruit and dodge the stones!';

  @override
  String get arrowKeysHint => 'On a computer, the arrow keys work too.';

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
  String get otherGamesButton => 'Other games';

  @override
  String get gamesTitle => 'What shall we play?';

  @override
  String get memoryTitle => 'Fruit memory';

  @override
  String get memoryHint =>
      'Turn over two cards at a time and find all the pairs!';

  @override
  String cardsCount(int count) {
    return '$count cards';
  }

  @override
  String get memoryCard => 'Card';

  @override
  String pairsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pairs found',
      one: '1 pair found',
    );
    return '$_temp0';
  }

  @override
  String get hideTitle => 'Hide and seek';

  @override
  String get hideHint =>
      'Chigüi hides under a box, then the boxes move. Keep your eyes on it!';

  @override
  String get hideWatch => 'Keep your eyes on Chigüi\'s box…';

  @override
  String get hidePick => 'Where is Chigüi?';

  @override
  String get hideFound => 'You found me!';

  @override
  String get hideMissed => 'Peekaboo! I was over here!';

  @override
  String hideBox(int number) {
    return 'Box $number';
  }

  @override
  String timesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You found Chigüi $count times',
      one: 'You found Chigüi once',
      zero: 'Chigüi is great at hiding!',
    );
    return '$_temp0';
  }

  @override
  String get bathTitle => 'Bath time';

  @override
  String get bathHint =>
      'Chigüi got super messy playing! Pop Chigüi into the tub, then pick the right things to clean off the sticky spots.';

  @override
  String get bathArrive => 'Here comes Chigüi, sticky up to the ears!';

  @override
  String get bathHopIn => 'Tap Chigüi to hop into the tub!';

  @override
  String get bathWash => 'Pick something and clean the sticky spots';

  @override
  String get bathYuzu => 'Squeaky clean! Toss some yuzus into the water';

  @override
  String get bathSoak => 'Ahhh… a cozy yuzu soak';

  @override
  String get bathDry => 'Out of the water! Dry Chigüi with the towel';

  @override
  String get bathDone => 'So fluffy and shiny!';

  @override
  String bathSpots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sticky spots cleaned off',
      one: '1 sticky spot cleaned off',
    );
    return '$_temp0';
  }

  @override
  String get bathToolSoap => 'Soap';

  @override
  String get bathToolBrush => 'Brush';

  @override
  String get bathToolLadle => 'Water ladle';

  @override
  String get bathToolYuzu => 'Yuzu';

  @override
  String get bathToolTowel => 'Towel';

  @override
  String get chompSound => 'Chomp!';

  @override
  String get ouchSound => 'Ouch!';

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
  String get stickerBoughtStatus => 'New sticker! Stick it in your album.';

  @override
  String get albumButton => 'Sticker album';

  @override
  String get albumTitle => 'Chigüi\'s album';

  @override
  String get albumHint => 'Drag each sticker to its spot';

  @override
  String get albumEmpty =>
      'No stickers yet. Buy them in the shop with your coins!';

  @override
  String get albumStuck => 'Stuck! Looks great.';

  @override
  String get albumAllStuck => 'All stuck! More stickers wait in the shop.';

  @override
  String get albumComplete => 'Album complete! 100% achievement unlocked.';

  @override
  String get newStickersButton => 'Have you seen the new stickers?';

  @override
  String get updateButton => 'New version! Update';

  @override
  String get whatsNewLabel => 'What\'s new';

  @override
  String get whatsNewOk => 'Cool!';

  @override
  String get newStickerLabel => 'New!';

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

  @override
  String get walkButton => 'Walk';

  @override
  String get walkTitle => 'Walk with Chigüi';

  @override
  String get walkIntro =>
      'Walk with your phone in your hand, or tap the feet one after the other!';

  @override
  String get walkIntroTapping =>
      'Tap the feet to walk with Chigüi, as fast as you like!';

  @override
  String get startWalkButton => 'Let\'s go!';

  @override
  String get sensorWalkHint =>
      'Walk with the phone in your hand, or tap the feet!';

  @override
  String get pedometerWalkHint =>
      'Walk for real (even with the phone in your pocket), or tap the feet!';

  @override
  String get tapFeetHint => 'Left, right, left, right…';

  @override
  String get leftFoot => 'left foot';

  @override
  String get rightFoot => 'right foot';

  @override
  String nextWalkProgress(int steps, int goal) {
    return '$steps of $goal steps to the next walk';
  }

  @override
  String walksToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count walks today',
      one: '1 walk today',
    );
    return '$_temp0';
  }

  @override
  String get walksCapped =>
      'So many walks! Chigüi\'s batteries are flat. More tomorrow!';

  @override
  String get muteSounds => 'Mute sounds';

  @override
  String get unmuteSounds => 'Turn sounds on';

  @override
  String get remindersButton => 'Reminders';

  @override
  String get remindersOffInfo =>
      'Chigüi can send a gentle reminder at mealtimes and when it\'s toilet time, never during class or at night. They are off for now.';

  @override
  String get remindersOnInfo =>
      'Reminders are on: a few a day, at mealtimes and toilet time. They stop by themselves after a day without playing.';

  @override
  String get remindersTurnOn => 'Turn on';

  @override
  String get remindersTurnOff => 'Turn off';

  @override
  String get remindersDenied =>
      'Notifications for Chigüi are blocked in the phone\'s settings.';

  @override
  String get remindersOpenSettings => 'Open settings';

  @override
  String get reminderMeal =>
      'It\'s mealtime! Chigüi would love something yummy.';

  @override
  String get reminderPotty => 'Chigüi needs the toilet! Can you help?';

  @override
  String get reminderChannel => 'Chigüi\'s routine';

  @override
  String get packsSection => 'Packs';

  @override
  String get packGeekName => 'Geek pack';

  @override
  String get packSweetName => 'Sweet pack';

  @override
  String get packOwned => 'Yours!';

  @override
  String get packWaiting => 'Waiting for a grown-up to approve…';

  @override
  String get buyPackTitle => 'This costs real money';

  @override
  String get buyPackBody =>
      'Ask a grown-up first. The store will ask them to confirm and pay.';

  @override
  String get buyPackConfirm => 'Continue to payment';

  @override
  String get buyPackCancel => 'Not now';

  @override
  String get packBoughtStatus => 'New pack unlocked! Look in Accessories.';

  @override
  String get packErrorStatus =>
      'The purchase didn\'t go through. Try again later.';

  @override
  String get itemPixelGlasses => 'Pixel glasses';

  @override
  String get itemWizardHat => 'Wizard hat';

  @override
  String get itemLaptop => 'Laptop with stickers';

  @override
  String get itemBunnyEars => 'Bunny ears';

  @override
  String get itemHeartGlasses => 'Heart glasses';

  @override
  String get itemCupcake => 'Cupcake';

  @override
  String get itemCap => 'Cap';

  @override
  String get itemVikingHelmet => 'Viking helmet';

  @override
  String get itemCrown => 'Crown';

  @override
  String get itemMustache => 'Mustache';

  @override
  String get itemGlasses3d => '3D glasses';

  @override
  String get itemBandana => 'Bandana';

  @override
  String get itemMedal => 'Medal';

  @override
  String get itemCape => 'Superhero cape';

  @override
  String get itemBalloon => 'Heart balloon';

  @override
  String get itemSkateboard => 'Skateboard';

  @override
  String get itemRetroConsole => 'Retro console';

  @override
  String get tapsCapped =>
      'Phew, phew! Chigüi is out of breath from so much tapping. More tomorrow, or go for a real walk!';

  @override
  String get piggyBankFull =>
      'Chigüi\'s piggy bank is full for today! Playing is still fun.';

  @override
  String get schoolStatus => 'I\'m in class right now! See you after school.';
}
