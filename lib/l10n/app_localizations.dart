import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Game title, shown in the browser tab and window title.
  ///
  /// In en, this message translates to:
  /// **'Chigüi'**
  String get appTitle;

  /// The pet's name. Chigüi is gender-neutral.
  ///
  /// In en, this message translates to:
  /// **'Chigüi'**
  String get chiguiName;

  /// Idle prompt under the pet inviting the player to tap it.
  ///
  /// In en, this message translates to:
  /// **'Tap Chigüi to say hi'**
  String get tapHint;

  /// Screen reader hint for the tap action on the pet.
  ///
  /// In en, this message translates to:
  /// **'pet Chigüi'**
  String get petAction;

  /// After petting once affection is high.
  ///
  /// In en, this message translates to:
  /// **'Chigüi is happy!'**
  String get lovedStatus;

  /// After petting while affection is still low: invites more petting, never sad.
  ///
  /// In en, this message translates to:
  /// **'Chigüi liked that! More cuddles, please?'**
  String get pettedLowStatus;

  /// After petting while affection is medium.
  ///
  /// In en, this message translates to:
  /// **'That feels nice! A little more?'**
  String get pettedMidStatus;

  /// Shown briefly after Chigüi eats.
  ///
  /// In en, this message translates to:
  /// **'Yum! Thank you!'**
  String get ateStatus;

  /// Shown when the player feeds Chigüi while full. Friendly, never scolding.
  ///
  /// In en, this message translates to:
  /// **'Chigüi has had enough for now'**
  String get fullStatus;

  /// Gentle hint when food is low. Must not sound urgent or guilt-inducing.
  ///
  /// In en, this message translates to:
  /// **'Chigüi could go for a snack'**
  String get wantsFood;

  /// Gentle hint when affection is low.
  ///
  /// In en, this message translates to:
  /// **'Chigüi would love some cuddles'**
  String get wantsAffection;

  /// Gentle hint when fun is low.
  ///
  /// In en, this message translates to:
  /// **'Chigüi feels like playing'**
  String get wantsFun;

  /// Button that gives Chigüi a snack.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feedButton;

  /// Name of the food need meter.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get needFood;

  /// Name of the affection need meter.
  ///
  /// In en, this message translates to:
  /// **'Affection'**
  String get needAffection;

  /// Name of the fun need meter.
  ///
  /// In en, this message translates to:
  /// **'Fun'**
  String get needFun;

  /// Screen reader label for a need meter.
  ///
  /// In en, this message translates to:
  /// **'{need}: {percent}%'**
  String needMeterLabel(String need, int percent);

  /// Button that takes Chigüi to the toilet when they need to go.
  ///
  /// In en, this message translates to:
  /// **'Toilet'**
  String get toiletButton;

  /// Button that sends a sleepy Chigüi to bed.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get bedButton;

  /// Button that takes a sick Chigüi to the vet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get vetButton;

  /// Screen reader label for tapping a mess to clean it.
  ///
  /// In en, this message translates to:
  /// **'clean up'**
  String get cleanAction;

  /// Shown while Chigüi sleeps.
  ///
  /// In en, this message translates to:
  /// **'Shh… Chigüi is sleeping'**
  String get asleepStatus;

  /// Shown while Chigüi is sick. Calm, never scary or guilt-inducing.
  ///
  /// In en, this message translates to:
  /// **'Chigüi doesn\'t feel well. Time for the vet!'**
  String get sickStatus;

  /// Shown while Chigüi needs to poop.
  ///
  /// In en, this message translates to:
  /// **'Chigüi needs the toilet!'**
  String get pottyStatus;

  /// Shown at bedtime, until Chigüi is sent to bed.
  ///
  /// In en, this message translates to:
  /// **'Chigüi is sleepy'**
  String get sleepyStatus;

  /// Shown during a mealtime window before Chigüi has eaten.
  ///
  /// In en, this message translates to:
  /// **'It\'s mealtime!'**
  String get mealtimeStatus;

  /// Shown after Chigüi went to bed alone, until petted. Light-hearted, not scolding.
  ///
  /// In en, this message translates to:
  /// **'Nobody sent Chigüi to bed, so Chigüi is a bit grumpy. A cuddle will help!'**
  String get grumpyStatus;

  /// Shown while there is an uncleaned accident.
  ///
  /// In en, this message translates to:
  /// **'Something smells… time to clean up!'**
  String get messStatus;

  /// Shown after taking Chigüi to the toilet.
  ///
  /// In en, this message translates to:
  /// **'Phew, much better!'**
  String get reliefStatus;

  /// Shown after the vet visit.
  ///
  /// In en, this message translates to:
  /// **'All better! So brave!'**
  String get curedStatus;

  /// Shown after cleaning up a mess.
  ///
  /// In en, this message translates to:
  /// **'All clean!'**
  String get cleanedStatus;

  /// Button that opens the fruit-catching minigame.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get playButton;

  /// Screen reader label for the player's coin total.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 coin} other{{count} coins}}'**
  String coinsLabel(int count);

  /// Name of the minigame.
  ///
  /// In en, this message translates to:
  /// **'Fruit catch'**
  String get minigameTitle;

  /// How to play, shown before starting.
  ///
  /// In en, this message translates to:
  /// **'Drag to move Chigüi and catch the fruit!'**
  String get minigameHint;

  /// Starts a minigame round.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startButton;

  /// Time left in the round.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String secondsLeft(int seconds);

  /// Round result. Never discouraging.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No fruit this time} =1{1 fruit caught} other{{count} fruits caught}}'**
  String fruitsCaught(int count);

  /// Coins earned in the round.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Chigüi had fun anyway!} =1{+1 coin} other{+{count} coins}}'**
  String coinsEarned(int count);

  /// Title on the results screen.
  ///
  /// In en, this message translates to:
  /// **'Great game!'**
  String get roundDone;

  /// Starts another round.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get playAgainButton;

  /// Leaves the minigame.
  ///
  /// In en, this message translates to:
  /// **'Back home'**
  String get backHomeButton;

  /// Big, cute eating sound shown when Chigüi catches fruit in the minigame. Keep very short.
  ///
  /// In en, this message translates to:
  /// **'Chomp!'**
  String get chompSound;

  /// Shown when the player's real steps complete a walk with Chigüi.
  ///
  /// In en, this message translates to:
  /// **'What a lovely walk!'**
  String get walkedStatus;

  /// Screen reader label for today's step counter.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 step today} other{{count} steps today}}'**
  String stepsLabel(int count);

  /// Button that opens the shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shopButton;

  /// Shop screen title.
  ///
  /// In en, this message translates to:
  /// **'Chigüi\'s shop'**
  String get shopTitle;

  /// Default line in the shop.
  ///
  /// In en, this message translates to:
  /// **'What shall we get today?'**
  String get shopHint;

  /// Shop section for items sold only in their season.
  ///
  /// In en, this message translates to:
  /// **'Seasonal'**
  String get seasonalSection;

  /// Shop section for wearable items.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessoriesSection;

  /// Shop section for collectible stickers.
  ///
  /// In en, this message translates to:
  /// **'Stickers'**
  String get stickersSection;

  /// Puts an owned accessory on Chigüi.
  ///
  /// In en, this message translates to:
  /// **'Wear'**
  String get wearButton;

  /// Removes a worn accessory.
  ///
  /// In en, this message translates to:
  /// **'Take off'**
  String get takeOffButton;

  /// Shown on stickers already owned.
  ///
  /// In en, this message translates to:
  /// **'In your album'**
  String get inAlbum;

  /// After buying an accessory.
  ///
  /// In en, this message translates to:
  /// **'New look unlocked!'**
  String get boughtStatus;

  /// After buying a sticker.
  ///
  /// In en, this message translates to:
  /// **'Sticker added to your album!'**
  String get stickerBoughtStatus;

  /// Shown when trying to buy without enough coins. Half geeky (HTTP 402 Payment Required), half funny; never pushy.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Error 402: 1 coin missing. One round of Fruit catch will fix it!} other{Error 402: {count} coins missing. A few rounds of Fruit catch will fix it!}}'**
  String notEnoughCoins(int count);

  /// Season name badge (October).
  ///
  /// In en, this message translates to:
  /// **'Spooktober'**
  String get seasonSpooktober;

  /// Season name badge (1 Dec – 6 Jan).
  ///
  /// In en, this message translates to:
  /// **'Christmas'**
  String get seasonChristmas;

  /// Season name badge.
  ///
  /// In en, this message translates to:
  /// **'Spring'**
  String get seasonSpring;

  /// Season name badge.
  ///
  /// In en, this message translates to:
  /// **'Summer'**
  String get seasonSummer;

  /// On a seasonal item outside its season. Reassuring, no urgency.
  ///
  /// In en, this message translates to:
  /// **'Back every October'**
  String get backSpooktober;

  /// On a seasonal item outside its season.
  ///
  /// In en, this message translates to:
  /// **'Back every Christmas'**
  String get backChristmas;

  /// On a seasonal item outside its season.
  ///
  /// In en, this message translates to:
  /// **'Back every spring'**
  String get backSpring;

  /// On a seasonal item outside its season.
  ///
  /// In en, this message translates to:
  /// **'Back every summer'**
  String get backSummer;

  /// Tapping a Spooktober item out of season. Half geeky, half funny.
  ///
  /// In en, this message translates to:
  /// **'The ghosts are still snoring in their crypt. Come back in October!'**
  String get tooEarlySpooktober;

  /// Tapping a Christmas item out of season. Half geeky, half funny.
  ///
  /// In en, this message translates to:
  /// **'Santa\'s elves are still compiling the presents. Come back in December!'**
  String get tooEarlyChristmas;

  /// Tapping a spring item out of season. Half geeky, half funny.
  ///
  /// In en, this message translates to:
  /// **'The flowers are still in beta. Come back in spring!'**
  String get tooEarlySpring;

  /// Tapping a summer item out of season. Half geeky, half funny.
  ///
  /// In en, this message translates to:
  /// **'The beach is still loading… 42%. Come back in summer!'**
  String get tooEarlySummer;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Geek glasses'**
  String get itemGeekGlasses;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Woolly hat'**
  String get itemBeanie;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Scarf'**
  String get itemScarf;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Headphones'**
  String get itemHeadphones;

  /// Shop item (Spooktober).
  ///
  /// In en, this message translates to:
  /// **'Ghost costume'**
  String get itemGhost;

  /// Shop item (Spooktober).
  ///
  /// In en, this message translates to:
  /// **'Pumpkin'**
  String get itemPumpkin;

  /// Shop item (Christmas).
  ///
  /// In en, this message translates to:
  /// **'Santa hat'**
  String get itemSantaHat;

  /// Shop item (Christmas).
  ///
  /// In en, this message translates to:
  /// **'Christmas tree'**
  String get itemXmasTree;

  /// Shop item (spring).
  ///
  /// In en, this message translates to:
  /// **'Flower crown'**
  String get itemFlowerCrown;

  /// Shop item (spring).
  ///
  /// In en, this message translates to:
  /// **'Butterfly friend'**
  String get itemButterfly;

  /// Shop item (summer).
  ///
  /// In en, this message translates to:
  /// **'Surfboard'**
  String get itemSurfboard;

  /// Shop item (summer).
  ///
  /// In en, this message translates to:
  /// **'Diving mask and snorkel'**
  String get itemSnorkel;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Star sticker'**
  String get itemStickerStar;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Heart sticker'**
  String get itemStickerHeart;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Rocket sticker'**
  String get itemStickerRocket;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Gamepad sticker'**
  String get itemStickerGamepad;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Music sticker'**
  String get itemStickerMusic;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Ice cream sticker'**
  String get itemStickerIceCream;

  /// Opens the walk scene.
  ///
  /// In en, this message translates to:
  /// **'Walk'**
  String get walkButton;

  /// Walk scene title.
  ///
  /// In en, this message translates to:
  /// **'Walk with Chigüi'**
  String get walkTitle;

  /// Explains the walk scene before starting.
  ///
  /// In en, this message translates to:
  /// **'Walk with your phone in your hand, or tap the feet one after the other!'**
  String get walkIntro;

  /// Starts the walk.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get startWalkButton;

  /// Shown while real steps are counted from the phone's motion sensor.
  ///
  /// In en, this message translates to:
  /// **'Walking for real! Keep the phone in your hand.'**
  String get sensorWalkHint;

  /// Shown while the player taps the feet to walk.
  ///
  /// In en, this message translates to:
  /// **'Left, right, left, right…'**
  String get tapFeetHint;

  /// Shown when the same foot is tapped twice in a row.
  ///
  /// In en, this message translates to:
  /// **'The other foot!'**
  String get otherFoot;

  /// Screen reader label for the left foot button.
  ///
  /// In en, this message translates to:
  /// **'left foot'**
  String get leftFoot;

  /// Screen reader label for the right foot button.
  ///
  /// In en, this message translates to:
  /// **'right foot'**
  String get rightFoot;

  /// Progress towards the next completed walk.
  ///
  /// In en, this message translates to:
  /// **'{steps} of {goal} steps to the next walk'**
  String nextWalkProgress(int steps, int goal);

  /// Completed walks today.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 walk today} other{{count} walks today}}'**
  String walksToday(int count);

  /// When the daily walk rewards are used up. Half geeky, half funny; steps still count.
  ///
  /// In en, this message translates to:
  /// **'So many walks! Chigüi\'s batteries are flat. More tomorrow!'**
  String get walksCapped;

  /// Tooltip of the button that turns sound effects off.
  ///
  /// In en, this message translates to:
  /// **'Mute sounds'**
  String get muteSounds;

  /// Tooltip of the button that turns sound effects back on.
  ///
  /// In en, this message translates to:
  /// **'Turn sounds on'**
  String get unmuteSounds;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
