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
