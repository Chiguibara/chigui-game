// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Chigüi';

  @override
  String get chiguiName => 'Chigüi';

  @override
  String get tapHint => 'Tippe Chigüi an, um Hallo zu sagen';

  @override
  String get petAction => 'Chigüi streicheln';

  @override
  String get lovedStatus => 'Chigüi ist glücklich!';

  @override
  String get pettedLowStatus => 'Das hat Chigüi gefallen! Noch mehr Kuscheln?';

  @override
  String get pettedMidStatus => 'Wie schön! Noch ein bisschen?';

  @override
  String get ateStatus => 'Mjam! Danke!';

  @override
  String get fullStatus => 'Chigüi ist erst mal satt';

  @override
  String get wantsFood => 'Chigüi hätte Lust auf einen Snack';

  @override
  String get wantsAffection => 'Chigüi hätte gern ein paar Streicheleinheiten';

  @override
  String get wantsFun => 'Chigüi hat Lust zu spielen';

  @override
  String get feedButton => 'Füttern';

  @override
  String get needFood => 'Futter';

  @override
  String get needAffection => 'Zuneigung';

  @override
  String get needFun => 'Spaß';

  @override
  String needMeterLabel(String need, int percent) {
    return '$need: $percent %';
  }

  @override
  String get toiletButton => 'Aufs Klo';

  @override
  String get bedButton => 'Ab ins Bett';

  @override
  String get vetButton => 'Zum Tierarzt';

  @override
  String get cleanAction => 'sauber machen';

  @override
  String get asleepStatus => 'Pssst… Chigüi schläft';

  @override
  String get sickStatus => 'Chigüi geht es nicht gut. Ab zum Tierarzt!';

  @override
  String get pottyStatus => 'Chigüi muss aufs Klo!';

  @override
  String get sleepyStatus => 'Chigüi ist müde';

  @override
  String get mealtimeStatus => 'Essenszeit!';

  @override
  String get grumpyStatus =>
      'Keiner brachte Chigüi ins Bett, jetzt schmollt Chigüi. Kuscheln hilft!';

  @override
  String get messStatus => 'Hier riecht\'s komisch… Zeit zum Saubermachen!';

  @override
  String get reliefStatus => 'Puh, viel besser!';

  @override
  String get curedStatus => 'Alles wieder gut! So mutig!';

  @override
  String get cleanedStatus => 'Alles sauber!';

  @override
  String get playButton => 'Spielen';

  @override
  String coinsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Münzen',
      one: '1 Münze',
    );
    return '$_temp0';
  }

  @override
  String get minigameTitle => 'Obstfangen';

  @override
  String get minigameHint => 'Zieh Chigüi hin und her und fang das Obst!';

  @override
  String get startButton => 'Los geht\'s!';

  @override
  String secondsLeft(int seconds) {
    return '$seconds s';
  }

  @override
  String fruitsCaught(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Obst gefangen',
      one: '1 Obst gefangen',
      zero: 'Diesmal kein Obst',
    );
    return '$_temp0';
  }

  @override
  String coinsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count Münzen',
      one: '+1 Münze',
      zero: 'Spaß hatte Chigüi trotzdem!',
    );
    return '$_temp0';
  }

  @override
  String get roundDone => 'Tolles Spiel!';

  @override
  String get playAgainButton => 'Nochmal';

  @override
  String get backHomeButton => 'Zurück';

  @override
  String get chompSound => 'Mjam!';

  @override
  String get walkedStatus => 'Was für ein schöner Spaziergang!';

  @override
  String stepsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Schritte heute',
      one: '1 Schritt heute',
    );
    return '$_temp0';
  }

  @override
  String get shopButton => 'Laden';

  @override
  String get shopTitle => 'Chigüis Laden';

  @override
  String get shopHint => 'Was holen wir uns heute?';

  @override
  String get seasonalSection => 'Saisonal';

  @override
  String get accessoriesSection => 'Accessoires';

  @override
  String get stickersSection => 'Sticker';

  @override
  String get wearButton => 'Anziehen';

  @override
  String get takeOffButton => 'Ausziehen';

  @override
  String get inAlbum => 'In deinem Album';

  @override
  String get boughtStatus => 'Neuer Look freigeschaltet!';

  @override
  String get stickerBoughtStatus => 'Sticker ins Album geklebt!';

  @override
  String notEnoughCoins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Error 402: $count Münzen fehlen. Ein paar Runden Obstfangen, und das Problem ist gelöst!',
      one:
          'Error 402: 1 Münze fehlt. Eine Runde Obstfangen, und das Problem ist gelöst!',
    );
    return '$_temp0';
  }

  @override
  String get seasonSpooktober => 'Halloween';

  @override
  String get seasonChristmas => 'Weihnachten';

  @override
  String get seasonSpring => 'Frühling';

  @override
  String get seasonSummer => 'Sommer';

  @override
  String get backSpooktober => 'Kommt jeden Oktober wieder';

  @override
  String get backChristmas => 'Kommt jedes Weihnachten wieder';

  @override
  String get backSpring => 'Kommt jeden Frühling wieder';

  @override
  String get backSummer => 'Kommt jeden Sommer wieder';

  @override
  String get tooEarlySpooktober =>
      'Die Gespenster schnarchen noch in ihrer Gruft. Komm im Oktober wieder!';

  @override
  String get tooEarlyChristmas =>
      'Die Weihnachtswichtel kompilieren noch die Geschenke. Komm im Dezember wieder!';

  @override
  String get tooEarlySpring =>
      'Die Blumen sind noch in der Beta. Komm im Frühling wieder!';

  @override
  String get tooEarlySummer =>
      'Der Strand lädt noch… 42 %. Komm im Sommer wieder!';

  @override
  String get itemGeekGlasses => 'Nerd-Brille';

  @override
  String get itemBeanie => 'Wollmütze';

  @override
  String get itemScarf => 'Schal';

  @override
  String get itemHeadphones => 'Kopfhörer';

  @override
  String get itemGhost => 'Gespensterkostüm';

  @override
  String get itemPumpkin => 'Kürbis';

  @override
  String get itemSantaHat => 'Weihnachtsmütze';

  @override
  String get itemXmasTree => 'Weihnachtsbaum';

  @override
  String get itemFlowerCrown => 'Blumenkranz';

  @override
  String get itemButterfly => 'Schmetterlingsfreund';

  @override
  String get itemSurfboard => 'Surfbrett';

  @override
  String get itemSnorkel => 'Taucherbrille mit Schnorchel';

  @override
  String get itemStickerStar => 'Stern-Sticker';

  @override
  String get itemStickerHeart => 'Herz-Sticker';

  @override
  String get itemStickerRocket => 'Raketen-Sticker';

  @override
  String get itemStickerGamepad => 'Controller-Sticker';

  @override
  String get itemStickerMusic => 'Musik-Sticker';

  @override
  String get itemStickerIceCream => 'Eis-Sticker';

  @override
  String get walkButton => 'Spazieren';

  @override
  String get walkTitle => 'Spaziergang mit Chigüi';

  @override
  String get walkIntro =>
      'Lauf mit dem Handy in der Hand oder tippe abwechselnd auf die Füße!';

  @override
  String get walkIntroTapping =>
      'Tippe abwechselnd auf die Füße, um mit Chigüi spazieren zu gehen!';

  @override
  String get startWalkButton => 'Los!';

  @override
  String get sensorWalkHint =>
      'Lauf mit dem Handy in der Hand oder tippe auf die Füße!';

  @override
  String get pedometerWalkHint =>
      'Lauf richtig los (auch mit dem Handy in der Tasche) oder tippe auf die Füße!';

  @override
  String get tapFeetHint => 'Links, rechts, links, rechts…';

  @override
  String get otherFoot => 'Der andere Fuß!';

  @override
  String get leftFoot => 'linker Fuß';

  @override
  String get rightFoot => 'rechter Fuß';

  @override
  String nextWalkProgress(int steps, int goal) {
    return '$steps von $goal Schritten bis zum nächsten Spaziergang';
  }

  @override
  String walksToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spaziergänge heute',
      one: '1 Spaziergang heute',
    );
    return '$_temp0';
  }

  @override
  String get walksCapped =>
      'So viele Spaziergänge! Chigüis Akku ist leer. Morgen geht\'s weiter!';

  @override
  String get muteSounds => 'Ton aus';

  @override
  String get unmuteSounds => 'Ton an';

  @override
  String get packsSection => 'Pakete';

  @override
  String get packGeekName => 'Nerd-Paket';

  @override
  String get packSweetName => 'Süßes Paket';

  @override
  String get packOwned => 'Gehört dir!';

  @override
  String get packWaiting => 'Warte, bis ein Erwachsener zustimmt…';

  @override
  String get buyPackTitle => 'Das kostet echtes Geld';

  @override
  String get buyPackBody =>
      'Frag zuerst einen Erwachsenen. Der Store bittet dann um Bestätigung und Zahlung.';

  @override
  String get buyPackConfirm => 'Weiter zur Zahlung';

  @override
  String get buyPackCancel => 'Jetzt nicht';

  @override
  String get packBoughtStatus =>
      'Neues Paket freigeschaltet! Schau bei den Accessoires.';

  @override
  String get packErrorStatus =>
      'Der Kauf hat nicht geklappt. Versuch es später noch einmal.';

  @override
  String get itemPixelGlasses => 'Pixel-Brille';

  @override
  String get itemWizardHat => 'Zauberhut';

  @override
  String get itemLaptop => 'Laptop mit Stickern';

  @override
  String get itemBunnyEars => 'Hasenohren';

  @override
  String get itemHeartGlasses => 'Herzbrille';

  @override
  String get itemCupcake => 'Cupcake';

  @override
  String get itemCap => 'Cap';

  @override
  String get itemVikingHelmet => 'Wikingerhelm';

  @override
  String get itemCrown => 'Krone';

  @override
  String get itemMustache => 'Schnurrbart';

  @override
  String get itemGlasses3d => '3D-Brille';

  @override
  String get itemBandana => 'Halstuch';

  @override
  String get itemMedal => 'Medaille';

  @override
  String get itemCape => 'Superheldenumhang';

  @override
  String get itemBalloon => 'Herzballon';

  @override
  String get itemSkateboard => 'Skateboard';

  @override
  String get itemRetroConsole => 'Retro-Konsole';

  @override
  String get tapsCapped =>
      'Chigüis Pfoten sind müde vom Tippen! Morgen geht\'s weiter – oder lauf richtig los.';
}
