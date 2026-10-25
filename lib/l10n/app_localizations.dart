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
  /// **'Tap {name} to say hi'**
  String tapHint(String name);

  /// Screen reader hint for the tap action on the pet.
  ///
  /// In en, this message translates to:
  /// **'pet {name}'**
  String petAction(String name);

  /// After petting once affection is high.
  ///
  /// In en, this message translates to:
  /// **'{name} is happy!'**
  String lovedStatus(String name);

  /// After petting while affection is still low: invites more petting, never sad.
  ///
  /// In en, this message translates to:
  /// **'{name} liked that! More cuddles, please?'**
  String pettedLowStatus(String name);

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
  /// **'{name} has had enough for now'**
  String fullStatus(String name);

  /// Gentle hint when food is low. Must not sound urgent or guilt-inducing.
  ///
  /// In en, this message translates to:
  /// **'{name} could go for a snack'**
  String wantsFood(String name);

  /// Gentle hint when affection is low.
  ///
  /// In en, this message translates to:
  /// **'{name} would love some cuddles'**
  String wantsAffection(String name);

  /// Gentle hint when fun is low.
  ///
  /// In en, this message translates to:
  /// **'{name} feels like playing'**
  String wantsFun(String name);

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
  /// **'Shh… {name} is sleeping'**
  String asleepStatus(String name);

  /// Shown while Chigüi is sick. Calm, never scary or guilt-inducing.
  ///
  /// In en, this message translates to:
  /// **'{name} doesn\'t feel well. Time for the vet!'**
  String sickStatus(String name);

  /// Shown while Chigüi needs to poop.
  ///
  /// In en, this message translates to:
  /// **'{name} needs the toilet!'**
  String pottyStatus(String name);

  /// Shown at night while Chigüi is awake after being woken up, until falling asleep again.
  ///
  /// In en, this message translates to:
  /// **'{name} is sleepy'**
  String sleepyStatus(String name);

  /// Shown during a mealtime window before Chigüi has eaten.
  ///
  /// In en, this message translates to:
  /// **'It\'s mealtime!'**
  String get mealtimeStatus;

  /// Shown when a cuddle wakes a sleeping Chigüi, who yawns. Cheerful, never a reproach for waking them.
  ///
  /// In en, this message translates to:
  /// **'Yaaawn… {name} woke up!'**
  String yawnStatus(String name);

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
  /// **'Drag to move {name}: catch the fruit and dodge the stones!'**
  String minigameHint(String name);

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
  /// **'{count, plural, =0{{name} had fun anyway!} =1{+1 coin} other{+{count} coins}}'**
  String coinsEarned(int count, String name);

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
  /// **'{name} hides under a box, then the boxes move. Keep your eyes on it!'**
  String hideHint(String name);

  /// Hide-and-seek, while the boxes move.
  ///
  /// In en, this message translates to:
  /// **'Keep your eyes on {name}\'s box…'**
  String hideWatch(String name);

  /// Hide-and-seek, when the player picks a box.
  ///
  /// In en, this message translates to:
  /// **'Where is {name}?'**
  String hidePick(String name);

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
  /// **'{count, plural, =0{{name} is great at hiding!} =1{You found {name} once} other{You found {name} {count} times}}'**
  String timesFound(int count, String name);

  /// Title of the bath minigame (a game card and its intro). Short and cute.
  ///
  /// In en, this message translates to:
  /// **'Bath time'**
  String get bathTitle;

  /// Bath minigame intro: how to play. Chigüi got dirty having fun, never by neglect.
  ///
  /// In en, this message translates to:
  /// **'{name} got super messy playing! Pop {name} into the tub, then pick the right things to clean off the sticky spots.'**
  String bathHint(String name);

  /// Bath minigame status while Chigüi runs in, covered in sticky tar and gravel. Funny, never a reproach.
  ///
  /// In en, this message translates to:
  /// **'Here comes {name}, sticky up to the ears!'**
  String bathArrive(String name);

  /// Bath minigame status: tap Chigüi to jump into the wooden tub.
  ///
  /// In en, this message translates to:
  /// **'Tap {name} to hop into the tub!'**
  String bathHopIn(String name);

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
  /// **'Out of the water! Dry {name} with the towel'**
  String bathDry(String name);

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
  /// **'{name}\'s shop'**
  String shopTitle(String name);

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
  /// **'{name}\'s album'**
  String albumTitle(String name);

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

  /// Home screen button shown when a newer version of the game is ready: on the web, published while the page stayed open (reloads the page); in the Android app, downloaded from Google Play (restarts into it). One short line, gentle, never urgent.
  ///
  /// In en, this message translates to:
  /// **'New version! Update'**
  String get updateButton;

  /// Accessibility label of the dialog shown once after an update with the version's notes (the notes themselves come from distribution/whatsnew/).
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get whatsNewLabel;

  /// Button that closes the "What's new" dialog after an update. Short and cheerful.
  ///
  /// In en, this message translates to:
  /// **'Cool!'**
  String get whatsNewOk;

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
  /// **'Walk with {name}'**
  String walkTitle(String name);

  /// Explains the walk scene before starting.
  ///
  /// In en, this message translates to:
  /// **'Walk with your phone in your hand, or tap the feet one after the other!'**
  String get walkIntro;

  /// Explains the walk scene on PCs, where there is no motion sensor.
  ///
  /// In en, this message translates to:
  /// **'Tap the feet to walk with {name}, as fast as you like!'**
  String walkIntroTapping(String name);

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
  /// **'So many walks! {name}\'s batteries are flat. More tomorrow!'**
  String walksCapped(String name);

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
  /// **'{name} can send a gentle reminder at mealtimes and when it\'s toilet time, never during class or at night. They are off for now.'**
  String remindersOffInfo(String name);

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
  /// **'Notifications for {name} are blocked in the phone\'s settings.'**
  String remindersDenied(String name);

  /// Button under the blocked-notifications message that opens the phone's notification settings for the app.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get remindersOpenSettings;

  /// Notification at the start of a mealtime, while the game is closed. Gentle, never guilt-tripping.
  ///
  /// In en, this message translates to:
  /// **'It\'s mealtime! {name} would love something yummy.'**
  String reminderMeal(String name);

  /// Notification when Chigüi needs the toilet, while the game is closed. Gentle, never guilt-tripping.
  ///
  /// In en, this message translates to:
  /// **'{name} needs the toilet! Can you help?'**
  String reminderPotty(String name);

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
  /// **'Phew, phew! {name} is out of breath from so much tapping. More tomorrow, or go for a real walk!'**
  String tapsCapped(String name);

  /// Minigame results when the daily coin limit is reached. Cheerful: playing still raises fun; never 'you can't'.
  ///
  /// In en, this message translates to:
  /// **'{name}\'s piggy bank is full for today! Playing is still fun.'**
  String piggyBankFull(String name);

  /// Chigüi speaking after being petted during class time, while happily turning the pages of the book faster.
  ///
  /// In en, this message translates to:
  /// **'Page after page! Studying is faster with you.'**
  String get studyStatus;

  /// Title of the maths minigame (a game card and its intro). Short.
  ///
  /// In en, this message translates to:
  /// **'Maths class'**
  String get mathTitle;

  /// Maths minigame intro: how to play. Calm, no pressure; mistakes cost nothing.
  ///
  /// In en, this message translates to:
  /// **'{name} brought maths homework! Pick a level and tap the right answer. No rush, and mistakes don\'t matter.'**
  String mathHint(String name);

  /// Maths level button: first sums, results up to 10.
  ///
  /// In en, this message translates to:
  /// **'Sums to 10'**
  String get mathLevelSums;

  /// Maths level button: sums and subtractions up to 20.
  ///
  /// In en, this message translates to:
  /// **'Up to 20'**
  String get mathLevelUpTo20;

  /// Maths level button: sums and subtractions up to 100, with carrying.
  ///
  /// In en, this message translates to:
  /// **'Up to 100'**
  String get mathLevelUpTo100;

  /// Maths level button: the times tables and dividing by them.
  ///
  /// In en, this message translates to:
  /// **'Times tables'**
  String get mathLevelTables;

  /// Maths level button: two-digit multiplications and long divisions.
  ///
  /// In en, this message translates to:
  /// **'Multiply and divide'**
  String get mathLevelMultiplyDivide;

  /// Maths level button: simple fractions and decimals.
  ///
  /// In en, this message translates to:
  /// **'Fractions and decimals'**
  String get mathLevelFractions;

  /// Maths level button: negative numbers, powers, square roots, order of operations (first year of secondary school).
  ///
  /// In en, this message translates to:
  /// **'Negatives and powers'**
  String get mathLevelIntegers;

  /// Maths level button: first-degree equations, percentages, brackets (second year of secondary school).
  ///
  /// In en, this message translates to:
  /// **'Equations and %'**
  String get mathLevelEquations;

  /// Maths minigame, after a wrong answer: gentle, the player just picks again.
  ///
  /// In en, this message translates to:
  /// **'Almost! Try another one.'**
  String get mathTryAgain;

  /// Maths result: answers right on the first try.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total} right first time!'**
  String mathRightFirstTime(int count, int total);

  /// Maths notation: 'of' in '3/4 of 20' and '25% of 80'. Lowercase, one word.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get mathOf;

  /// Maths notation: the multiplication sign used at school in this language.
  ///
  /// In en, this message translates to:
  /// **'×'**
  String get mathTimes;

  /// Maths notation: the division sign used at school in this language.
  ///
  /// In en, this message translates to:
  /// **'÷'**
  String get mathDivide;

  /// Maths notation: the decimal separator, e.g. 2.5.
  ///
  /// In en, this message translates to:
  /// **'.'**
  String get mathDecimalPoint;

  /// Maths notation: a percentage, with this language's spacing.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String mathPercent(int percent);

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Pizza sticker'**
  String get itemStickerPizza;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Burger sticker'**
  String get itemStickerBurger;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Ramen sticker'**
  String get itemStickerRamen;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Croissant sticker'**
  String get itemStickerCroissant;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Cake sticker'**
  String get itemStickerCake;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Cookie sticker'**
  String get itemStickerCookie;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Hot chocolate sticker'**
  String get itemStickerCocoa;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Moon sticker'**
  String get itemStickerMoon;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Sun sticker'**
  String get itemStickerSun;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Earth sticker'**
  String get itemStickerEarth;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Satellite sticker'**
  String get itemStickerSatellite;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Galaxy sticker'**
  String get itemStickerGalaxy;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Sparkles sticker'**
  String get itemStickerSparkles;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'D-pad sticker'**
  String get itemStickerDpad;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Robot sticker'**
  String get itemStickerRobot;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Puzzle piece sticker'**
  String get itemStickerPuzzle;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Dice sticker'**
  String get itemStickerDice;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Chip sticker'**
  String get itemStickerChip;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Keyboard sticker'**
  String get itemStickerKeyboard;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Trophy sticker'**
  String get itemStickerTrophy;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Leaf sticker'**
  String get itemStickerLeaf;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Flower sticker'**
  String get itemStickerFlower;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Lotus sticker'**
  String get itemStickerLotus;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Water drop sticker'**
  String get itemStickerDrop;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Waves sticker'**
  String get itemStickerWaves;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Forest sticker'**
  String get itemStickerForest;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Paw print sticker'**
  String get itemStickerPaw;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Bee sticker'**
  String get itemStickerBee;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Piano sticker'**
  String get itemStickerPiano;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Headphones sticker'**
  String get itemStickerHeadphones;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Microphone sticker'**
  String get itemStickerMic;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Record sticker'**
  String get itemStickerVinyl;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Paint palette sticker'**
  String get itemStickerPalette;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Paintbrush sticker'**
  String get itemStickerBrush;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Theatre masks sticker'**
  String get itemStickerMasks;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Book sticker'**
  String get itemStickerBook;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Pencil sticker'**
  String get itemStickerPencil;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Calculator sticker'**
  String get itemStickerCalculator;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Science sticker'**
  String get itemStickerFlask;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Bright idea sticker'**
  String get itemStickerIdea;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'School bag sticker'**
  String get itemStickerBackpack;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Graduation cap sticker'**
  String get itemStickerGradCap;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Set square sticker'**
  String get itemStickerRuler;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Rainbow sticker'**
  String get itemStickerRainbow;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Cloud sticker'**
  String get itemStickerCloud;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Smiley sticker'**
  String get itemStickerSmiley;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Present sticker'**
  String get itemStickerGift;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Confetti sticker'**
  String get itemStickerParty;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Umbrella sticker'**
  String get itemStickerUmbrella;

  /// Shop item.
  ///
  /// In en, this message translates to:
  /// **'Gem sticker'**
  String get itemStickerDiamond;

  /// Title of a themed page of the sticker album, and of its shop section: Food: snacks and treats. Short.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get albumPageFood;

  /// Title of a themed page of the sticker album, and of its shop section: Space. Short.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get albumPageSpace;

  /// Title of a themed page of the sticker album, and of its shop section: Video games and geeky things. Short.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get albumPageGames;

  /// Title of a themed page of the sticker album, and of its shop section: Nature and the pond. Short.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get albumPageNature;

  /// Title of a themed page of the sticker album, and of its shop section: Music and art. Short.
  ///
  /// In en, this message translates to:
  /// **'Music and art'**
  String get albumPageMusic;

  /// Title of a themed page of the sticker album, and of its shop section: School and maths. Short.
  ///
  /// In en, this message translates to:
  /// **'School'**
  String get albumPageSchool;

  /// Title of a themed page of the sticker album, and of its shop section: Cute, happy things. Short.
  ///
  /// In en, this message translates to:
  /// **'Cute things'**
  String get albumPageCute;

  /// Title of the achievements screen, and the album's button (tooltip) that opens it.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// Shown with the medal when an achievement is earned. Cheerful.
  ///
  /// In en, this message translates to:
  /// **'New achievement!'**
  String get achievementUnlocked;

  /// After earning an achievement: where to see it (the trophy button in the sticker album).
  ///
  /// In en, this message translates to:
  /// **'You\'ll find it in the album.'**
  String get achievementWhere;

  /// Button that closes the new achievement message.
  ///
  /// In en, this message translates to:
  /// **'Yay!'**
  String get achievementOk;

  /// Achievements screen: how many are earned.
  ///
  /// In en, this message translates to:
  /// **'{count} of {total}'**
  String achievementsCount(int count, int total);

  /// Achievement name.
  ///
  /// In en, this message translates to:
  /// **'The collector'**
  String get achievementCollector;

  /// How to earn the collector achievement.
  ///
  /// In en, this message translates to:
  /// **'Buy every sticker in the shop.'**
  String get achievementCollectorHow;

  /// Achievement name, for the fruit catch minigame.
  ///
  /// In en, this message translates to:
  /// **'Fruit muncher'**
  String get achievementFruitMuncher;

  /// How to earn the fruit muncher achievement.
  ///
  /// In en, this message translates to:
  /// **'Catch {count} or more fruits in a round without a single stone.'**
  String achievementFruitMuncherHow(int count);

  /// Achievement name, for the bath minigame.
  ///
  /// In en, this message translates to:
  /// **'Cleanest in the pond'**
  String get achievementCleanestInPond;

  /// How to earn the cleanest in the pond achievement.
  ///
  /// In en, this message translates to:
  /// **'Give {name} a whole bath without picking a wrong thing even once.'**
  String achievementCleanestInPondHow(String name);

  /// Achievement name, for hide and seek.
  ///
  /// In en, this message translates to:
  /// **'Capybara eye'**
  String get achievementCapybaraEye;

  /// How to earn the capybara eye achievement.
  ///
  /// In en, this message translates to:
  /// **'Find {name} in every turn of hide and seek.'**
  String achievementCapybaraEyeHow(String name);

  /// Achievement name, for the memory minigame.
  ///
  /// In en, this message translates to:
  /// **'Capybara memory'**
  String get achievementCapybaraMemory;

  /// How to earn the capybara memory achievement: no avoidable misses.
  ///
  /// In en, this message translates to:
  /// **'Finish a memory game without missing a pair you had already seen.'**
  String get achievementCapybaraMemoryHow;

  /// Achievement name, for the maths minigame.
  ///
  /// In en, this message translates to:
  /// **'Maths whiz'**
  String get achievementMathWhiz;

  /// How to earn the maths whiz achievement.
  ///
  /// In en, this message translates to:
  /// **'Get all ten right the first time in maths class.'**
  String get achievementMathWhizHow;

  /// Album button (tooltip) to turn back a page.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get albumPreviousPage;

  /// Album button (tooltip) to turn to the next page.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get albumNextPage;

  /// Album status line when this page's loose stickers are all stuck but other pages still have loose ones.
  ///
  /// In en, this message translates to:
  /// **'More loose stickers wait on other pages.'**
  String get albumOtherPages;

  /// Home screen button (tooltip) next to the pet's name that opens the rename dialog.
  ///
  /// In en, this message translates to:
  /// **'Change name'**
  String get renameButton;

  /// Title of the rename dialog; name is the current name.
  ///
  /// In en, this message translates to:
  /// **'What shall we call {name}?'**
  String renameTitle(String name);

  /// Label of the text field for the new name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get renameField;

  /// Rename dialog in a new game: the first name does not use the monthly change.
  ///
  /// In en, this message translates to:
  /// **'This first name is free; after that you can change it once a month.'**
  String get renameFirstFree;

  /// Rename dialog: the rule.
  ///
  /// In en, this message translates to:
  /// **'You can change the name once a month.'**
  String get renameMonthly;

  /// Rename dialog when this month's change is used. Gentle.
  ///
  /// In en, this message translates to:
  /// **'You can choose a new name again next month.'**
  String get renameWait;

  /// Rename dialog button that saves the new name.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get renameSave;

  /// Rename dialog button that closes it without changes.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get renameCancel;

  /// Chigüi speaking right after being given a new name: thoughtful, then happy.
  ///
  /// In en, this message translates to:
  /// **'Hmmm… {name}. I think I could get used to this new name.'**
  String renamedStatus(String name);

  /// Chigüi speaking, during class time (weekday mornings outside school holidays), while studying with a book. Playing is still allowed (e.g. children home sick), so never say to come back later.
  ///
  /// In en, this message translates to:
  /// **'Class time! I\'m studying hard, but a little game sounds fun too.'**
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
