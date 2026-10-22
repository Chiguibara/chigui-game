import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

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
    Locale('ca'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
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

  /// Shown while Chigüi sleeps at night. Nothing is blocked: tapping or playing wakes Chigüi up.
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

  /// Shown at night while Chigüi is awake after being woken up, until falling asleep again.
  ///
  /// In en, this message translates to:
  /// **'Chigüi is sleepy'**
  String get sleepyStatus;

  /// Shown during a mealtime window before Chigüi has eaten.
  ///
  /// In en, this message translates to:
  /// **'It\'s mealtime!'**
  String get mealtimeStatus;

  /// Shown when a cuddle wakes a sleeping Chigüi, who yawns. Cheerful, never a reproach for waking them.
  ///
  /// In en, this message translates to:
  /// **'Yaaawn… Chigüi woke up!'**
  String get yawnStatus;

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
  /// **'Drag to move Chigüi: catch the fruit and dodge the stones!'**
  String get minigameHint;

  /// Added under how to play fruit catch and the walk, on the web on a computer: the arrow keys move Chigüi or step with each foot.
  ///
  /// In en, this message translates to:
  /// **'On a computer, the arrow keys work too.'**
  String get arrowKeysHint;

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

  /// Leaves the minigames for the home screen.
  ///
  /// In en, this message translates to:
  /// **'Back home'**
  String get backHomeButton;

  /// Leaves a minigame for the list of games.
  ///
  /// In en, this message translates to:
  /// **'Other games'**
  String get otherGamesButton;

  /// Title of the screen that lists the minigames.
  ///
  /// In en, this message translates to:
  /// **'What shall we play?'**
  String get gamesTitle;

  /// Name of the memory card game, with fruit cards.
  ///
  /// In en, this message translates to:
  /// **'Fruit memory'**
  String get memoryTitle;

  /// How to play memory, shown before starting.
  ///
  /// In en, this message translates to:
  /// **'Turn over two cards at a time and find all the pairs!'**
  String get memoryHint;

  /// Button that starts memory with a board of this many cards.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String cardsCount(int count);

  /// Screen reader label for a memory card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get memoryCard;

  /// Memory result.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 pair found} other{{count} pairs found}}'**
  String pairsFound(int count);

  /// Name of the hide-and-seek game: Chigüi hides under one of three boxes that swap places.
  ///
  /// In en, this message translates to:
  /// **'Hide and seek'**
  String get hideTitle;

  /// How to play hide-and-seek, shown before starting.
  ///
  /// In en, this message translates to:
  /// **'Chigüi hides under a box, then the boxes move. Keep your eyes on it!'**
  String get hideHint;

  /// Hide-and-seek, while the boxes move.
  ///
  /// In en, this message translates to:
  /// **'Keep your eyes on Chigüi\'s box…'**
  String get hideWatch;

  /// Hide-and-seek, when the player picks a box.
  ///
  /// In en, this message translates to:
  /// **'Where is Chigüi?'**
  String get hidePick;

  /// Hide-and-seek, Chigüi was under the picked box. Chigüi speaks.
  ///
  /// In en, this message translates to:
  /// **'You found me!'**
  String get hideFound;

  /// Hide-and-seek, Chigüi was under another box and pops out, giggling. Playful, never a reproach.
  ///
  /// In en, this message translates to:
  /// **'Peekaboo! I was over here!'**
  String get hideMissed;

  /// Screen reader label for a hide-and-seek box, by position from the left.
  ///
  /// In en, this message translates to:
  /// **'Box {number}'**
  String hideBox(int number);

  /// Hide-and-seek result. Never discouraging.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Chigüi is great at hiding!} =1{You found Chigüi once} other{You found Chigüi {count} times}}'**
  String timesFound(int count);

  /// Title of the bath minigame (a game card and its intro). Short and cute.
  ///
  /// In en, this message translates to:
  /// **'Bath time'**
  String get bathTitle;

  /// Bath minigame intro: how to play. Chigüi got dirty having fun, never by neglect.
  ///
  /// In en, this message translates to:
  /// **'Chigüi got super messy playing! Pop Chigüi into the tub, then pick the right things to clean off the sticky spots.'**
  String get bathHint;

  /// Bath minigame status while Chigüi runs in, covered in sticky tar and gravel. Funny, never a reproach.
  ///
  /// In en, this message translates to:
  /// **'Here comes Chigüi, sticky up to the ears!'**
  String get bathArrive;

  /// Bath minigame status: tap Chigüi to jump into the wooden tub.
  ///
  /// In en, this message translates to:
  /// **'Tap Chigüi to hop into the tub!'**
  String get bathHopIn;

  /// Bath minigame status while cleaning: pick a tool (soap, brush, ladle) and clean the sticky spots. Does not say which tool.
  ///
  /// In en, this message translates to:
  /// **'Pick something and clean the sticky spots'**
  String get bathWash;

  /// Bath minigame status: Chigüi is clean, now drop yuzus (Japanese citrus) into the bath.
  ///
  /// In en, this message translates to:
  /// **'Squeaky clean! Toss some yuzus into the water'**
  String get bathYuzu;

  /// Bath minigame status: Chigüi relaxes in the warm water with yuzus.
  ///
  /// In en, this message translates to:
  /// **'Ahhh… a cozy yuzu soak'**
  String get bathSoak;

  /// Bath minigame status: Chigüi hopped out, rub them dry with the towel.
  ///
  /// In en, this message translates to:
  /// **'Out of the water! Dry Chigüi with the towel'**
  String get bathDry;

  /// Bath minigame status at the end: Chigüi is clean and dry.
  ///
  /// In en, this message translates to:
  /// **'So fluffy and shiny!'**
  String get bathDone;

  /// Bath minigame result: how many sticky spots were cleaned.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 sticky spot cleaned off} other{{count} sticky spots cleaned off}}'**
  String bathSpots(int count);

  /// Bath tool button (screen readers): a bar of soap.
  ///
  /// In en, this message translates to:
  /// **'Soap'**
  String get bathToolSoap;

  /// Bath tool button (screen readers): a scrubbing brush.
  ///
  /// In en, this message translates to:
  /// **'Brush'**
  String get bathToolBrush;

  /// Bath tool button (screen readers): a wooden water ladle (Japanese hishaku) to rinse.
  ///
  /// In en, this message translates to:
  /// **'Water ladle'**
  String get bathToolLadle;

  /// Bath tool button (screen readers): a yuzu fruit to drop into the bath.
  ///
  /// In en, this message translates to:
  /// **'Yuzu'**
  String get bathToolYuzu;

  /// Bath tool button (screen readers): a towel to dry Chigüi.
  ///
  /// In en, this message translates to:
  /// **'Towel'**
  String get bathToolTowel;

  /// Big, cute eating sound shown when Chigüi catches fruit in the minigame. Keep very short.
  ///
  /// In en, this message translates to:
  /// **'Chomp!'**
  String get chompSound;

  /// Cartoon exclamation shown when a falling stone bonks Chigüi in the minigame. Playful, not painful. Keep very short.
  ///
  /// In en, this message translates to:
  /// **'Ouch!'**
  String get ouchSound;

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
  /// **'New sticker! Stick it in your album.'**
  String get stickerBoughtStatus;

  /// Home screen button (tooltip) that opens the sticker album.
  ///
  /// In en, this message translates to:
  /// **'Sticker album'**
  String get albumButton;

  /// Title of the sticker album screen.
  ///
  /// In en, this message translates to:
  /// **'Chigüi\'s album'**
  String get albumTitle;

  /// Album status line while there are loose stickers to drag onto their spots.
  ///
  /// In en, this message translates to:
  /// **'Drag each sticker to its spot'**
  String get albumHint;

  /// Album status line when the player owns no stickers yet. Gentle, never pushy.
  ///
  /// In en, this message translates to:
  /// **'No stickers yet. Buy them in the shop with your coins!'**
  String get albumEmpty;

  /// Album status line right after sticking a sticker in its spot.
  ///
  /// In en, this message translates to:
  /// **'Stuck! Looks great.'**
  String get albumStuck;

  /// Album status line when every owned sticker is stuck but the shop has more.
  ///
  /// In en, this message translates to:
  /// **'All stuck! More stickers wait in the shop.'**
  String get albumAllStuck;

  /// Album status line when every sticker is stuck. A bit geeky.
  ///
  /// In en, this message translates to:
  /// **'Album complete! 100% achievement unlocked.'**
  String get albumComplete;

  /// Home screen button shown after an update adds stickers; opens the shop. Friendly, never pushy.
  ///
  /// In en, this message translates to:
  /// **'Have you seen the new stickers?'**
  String get newStickersButton;

  /// Small tag on stickers that came with an update, in the shop.
  ///
  /// In en, this message translates to:
  /// **'New!'**
  String get newStickerLabel;

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

  /// Explains the walk scene on PCs, where there is no motion sensor.
  ///
  /// In en, this message translates to:
  /// **'Tap the feet to walk with Chigüi, as fast as you like!'**
  String get walkIntroTapping;

  /// Starts the walk.
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get startWalkButton;

  /// Shown in the walk on phones' browsers: real steps from the motion sensor and the feet both count.
  ///
  /// In en, this message translates to:
  /// **'Walk with the phone in your hand, or tap the feet!'**
  String get sensorWalkHint;

  /// Shown in the walk on the Android app: real steps (system pedometer) and the feet both count.
  ///
  /// In en, this message translates to:
  /// **'Walk for real (even with the phone in your pocket), or tap the feet!'**
  String get pedometerWalkHint;

  /// Shown while the player taps the feet to walk.
  ///
  /// In en, this message translates to:
  /// **'Left, right, left, right…'**
  String get tapFeetHint;

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

  /// Tooltip of the home screen bell button that opens the reminder settings (Android app), and the title of those settings.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersButton;

  /// Reminder settings while off: what reminders do. Calm, no pressure.
  ///
  /// In en, this message translates to:
  /// **'Chigüi can send a gentle reminder at mealtimes and when it\'s toilet time, never during class or at night. They are off for now.'**
  String get remindersOffInfo;

  /// Reminder settings while on.
  ///
  /// In en, this message translates to:
  /// **'Reminders are on: a few a day, at mealtimes and toilet time. They stop by themselves after a day without playing.'**
  String get remindersOnInfo;

  /// Button that turns reminders back on (asks the phone for permission if needed).
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get remindersTurnOn;

  /// Button that turns reminders off.
  ///
  /// In en, this message translates to:
  /// **'Turn off'**
  String get remindersTurnOff;

  /// Shown when the phone does not allow notifications for the app.
  ///
  /// In en, this message translates to:
  /// **'Notifications for Chigüi are blocked in the phone\'s settings.'**
  String get remindersDenied;

  /// Button under the blocked-notifications message that opens the phone's notification settings for the app.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get remindersOpenSettings;

  /// Notification at the start of a mealtime, while the game is closed. Gentle, never guilt-tripping.
  ///
  /// In en, this message translates to:
  /// **'It\'s mealtime! Chigüi would love something yummy.'**
  String get reminderMeal;

  /// Notification when Chigüi needs the toilet, while the game is closed. Gentle, never guilt-tripping.
  ///
  /// In en, this message translates to:
  /// **'Chigüi needs the toilet! Can you help?'**
  String get reminderPotty;

  /// Name of the notification channel, shown in the phone's notification settings.
  ///
  /// In en, this message translates to:
  /// **'Chigüi\'s routine'**
  String get reminderChannel;

  /// Shop section with real-money accessory packs (Android app only).
  ///
  /// In en, this message translates to:
  /// **'Packs'**
  String get packsSection;

  /// Name of a real-money pack.
  ///
  /// In en, this message translates to:
  /// **'Geek pack'**
  String get packGeekName;

  /// Name of a real-money pack.
  ///
  /// In en, this message translates to:
  /// **'Sweet pack'**
  String get packSweetName;

  /// On a pack already bought.
  ///
  /// In en, this message translates to:
  /// **'Yours!'**
  String get packOwned;

  /// While a parent's approval is pending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for a grown-up to approve…'**
  String get packWaiting;

  /// Title of the confirmation before buying a pack. Clear and calm.
  ///
  /// In en, this message translates to:
  /// **'This costs real money'**
  String get buyPackTitle;

  /// Explains who pays and approves. No pressure.
  ///
  /// In en, this message translates to:
  /// **'Ask a grown-up first. The store will ask them to confirm and pay.'**
  String get buyPackBody;

  /// Confirms and opens the platform store's own payment sheet (Google Play / App Store) inside the app; it does not go to any website.
  ///
  /// In en, this message translates to:
  /// **'Continue to payment'**
  String get buyPackConfirm;

  /// Closes the confirmation without buying.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get buyPackCancel;

  /// After a pack is bought.
  ///
  /// In en, this message translates to:
  /// **'New pack unlocked! Look in Accessories.'**
  String get packBoughtStatus;

  /// When the store reports a problem.
  ///
  /// In en, this message translates to:
  /// **'The purchase didn\'t go through. Try again later.'**
  String get packErrorStatus;

  /// Pack item.
  ///
  /// In en, this message translates to:
  /// **'Pixel glasses'**
  String get itemPixelGlasses;

  /// Pack item.
  ///
  /// In en, this message translates to:
  /// **'Wizard hat'**
  String get itemWizardHat;

  /// Pack item.
  ///
  /// In en, this message translates to:
  /// **'Laptop with stickers'**
  String get itemLaptop;

  /// Pack item.
  ///
  /// In en, this message translates to:
  /// **'Bunny ears'**
  String get itemBunnyEars;

  /// Pack item.
  ///
  /// In en, this message translates to:
  /// **'Heart glasses'**
  String get itemHeartGlasses;

  /// Pack item.
  ///
  /// In en, this message translates to:
  /// **'Cupcake'**
  String get itemCupcake;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Cap'**
  String get itemCap;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Viking helmet'**
  String get itemVikingHelmet;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Crown'**
  String get itemCrown;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Mustache'**
  String get itemMustache;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'3D glasses'**
  String get itemGlasses3d;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Bandana'**
  String get itemBandana;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Medal'**
  String get itemMedal;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Superhero cape'**
  String get itemCape;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Heart balloon'**
  String get itemBalloon;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Skateboard'**
  String get itemSkateboard;

  /// Shop item (coins).
  ///
  /// In en, this message translates to:
  /// **'Retro console'**
  String get itemRetroConsole;

  /// In the walk, when tapped feet have reached their daily limit of walks: Chigüi pants, out of breath. Funny, never scolding; real steps still count.
  ///
  /// In en, this message translates to:
  /// **'Phew, phew! Chigüi is out of breath from so much tapping. More tomorrow, or go for a real walk!'**
  String get tapsCapped;

  /// Minigame results when the daily coin limit is reached. Cheerful: playing still raises fun; never 'you can't'.
  ///
  /// In en, this message translates to:
  /// **'Chigüi\'s piggy bank is full for today! Playing is still fun.'**
  String get piggyBankFull;

  /// Chigüi speaking, during class time (weekday mornings outside school holidays), when the minigame waits until after school.
  ///
  /// In en, this message translates to:
  /// **'I\'m in class right now! See you after school.'**
  String get schoolStatus;
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
      <String>['ca', 'de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
