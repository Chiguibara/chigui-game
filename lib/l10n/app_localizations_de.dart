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
  String tapHint(String name) {
    return 'Tippe $name an, um Hallo zu sagen';
  }

  @override
  String petAction(String name) {
    return '$name streicheln';
  }

  @override
  String lovedStatus(String name) {
    return '$name ist glücklich!';
  }

  @override
  String pettedLowStatus(String name) {
    return 'Das hat $name gefallen! Noch mehr Kuscheln?';
  }

  @override
  String get pettedMidStatus => 'Wie schön! Noch ein bisschen?';

  @override
  String get ateStatus => 'Mjam! Danke!';

  @override
  String fullStatus(String name) {
    return '$name ist erst mal satt';
  }

  @override
  String wantsFood(String name) {
    return '$name hätte Lust auf einen Snack';
  }

  @override
  String wantsAffection(String name) {
    return '$name hätte gern ein paar Streicheleinheiten';
  }

  @override
  String wantsFun(String name) {
    return '$name hat Lust zu spielen';
  }

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
  String get vetButton => 'Zum Tierarzt';

  @override
  String get cleanAction => 'sauber machen';

  @override
  String asleepStatus(String name) {
    return 'Pssst… $name schläft';
  }

  @override
  String sickStatus(String name) {
    return '$name geht es nicht gut. Ab zum Tierarzt!';
  }

  @override
  String pottyStatus(String name) {
    return '$name muss aufs Klo!';
  }

  @override
  String sleepyStatus(String name) {
    return '$name ist müde';
  }

  @override
  String get mealtimeStatus => 'Essenszeit!';

  @override
  String yawnStatus(String name) {
    return 'Uaaah… $name ist aufgewacht!';
  }

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
  String minigameHint(String name) {
    return 'Zieh $name hin und her: Fang das Obst und weich den Steinen aus!';
  }

  @override
  String get arrowKeysHint => 'Am Computer gehen auch die Pfeiltasten.';

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
  String coinsEarned(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count Münzen',
      one: '+1 Münze',
      zero: 'Spaß hatte $name trotzdem!',
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
  String get otherGamesButton => 'Andere Spiele';

  @override
  String get gamesTitle => 'Was spielen wir?';

  @override
  String get memoryTitle => 'Obst-Memory';

  @override
  String get memoryHint => 'Dreh immer zwei Karten um und finde alle Paare!';

  @override
  String cardsCount(int count) {
    return '$count Karten';
  }

  @override
  String get memoryCard => 'Karte';

  @override
  String pairsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Paare gefunden',
      one: '1 Paar gefunden',
    );
    return '$_temp0';
  }

  @override
  String get hideTitle => 'Verstecken';

  @override
  String hideHint(String name) {
    return '$name versteckt sich unter einer Kiste, dann werden die Kisten gemischt. Gut aufpassen!';
  }

  @override
  String hideWatch(String name) {
    return 'Behalte ${name}s Kiste im Blick …';
  }

  @override
  String hidePick(String name) {
    return 'Wo ist $name?';
  }

  @override
  String get hideFound => 'Gefunden!';

  @override
  String get hideMissed => 'Kuckuck! Hier war ich!';

  @override
  String hideBox(int number) {
    return 'Kiste $number';
  }

  @override
  String timesFound(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$name $count-mal gefunden',
      one: '$name einmal gefunden',
      zero: '$name kann sich super verstecken!',
    );
    return '$_temp0';
  }

  @override
  String get bathTitle => 'Badezeit';

  @override
  String bathHint(String name) {
    return '$name hat sich beim Spielen total eingesaut! Setz $name in den Zuber und wähl die richtigen Sachen gegen die klebrigen Flecken.';
  }

  @override
  String bathArrive(String name) {
    return 'Da kommt $name, klebrig bis zu den Ohren!';
  }

  @override
  String bathHopIn(String name) {
    return 'Tipp $name an – ab in den Zuber!';
  }

  @override
  String get bathWash => 'Wähl etwas aus und mach die klebrigen Flecken weg';

  @override
  String get bathYuzu => 'Blitzsauber! Wirf ein paar Yuzus ins Wasser';

  @override
  String get bathSoak => 'Ahhh… ein gemütliches Yuzu-Bad';

  @override
  String bathDry(String name) {
    return 'Raus aus dem Wasser! Trockne $name mit dem Handtuch';
  }

  @override
  String get bathDone => 'Flauschig und glänzend!';

  @override
  String bathSpots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count klebrige Flecken weg',
      one: '1 klebriger Fleck weg',
    );
    return '$_temp0';
  }

  @override
  String get bathToolSoap => 'Seife';

  @override
  String get bathToolBrush => 'Bürste';

  @override
  String get bathToolLadle => 'Schöpfkelle';

  @override
  String get bathToolYuzu => 'Yuzu';

  @override
  String get bathToolTowel => 'Handtuch';

  @override
  String get chompSound => 'Mjam!';

  @override
  String get ouchSound => 'Autsch!';

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
  String shopTitle(String name) {
    return '${name}s Laden';
  }

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
  String get stickerBoughtStatus => 'Neuer Sticker! Kleb ihn in dein Album.';

  @override
  String get albumButton => 'Stickeralbum';

  @override
  String albumTitle(String name) {
    return '${name}s Album';
  }

  @override
  String get albumHint => 'Zieh jeden Sticker an seinen Platz';

  @override
  String get albumEmpty =>
      'Noch keine Sticker. Kauf sie im Laden mit deinen Münzen!';

  @override
  String get albumStuck => 'Klebt! Sieht super aus.';

  @override
  String get albumAllStuck => 'Alle eingeklebt! Im Laden gibt es noch mehr.';

  @override
  String get albumComplete => 'Album komplett! Erfolg zu 100 % freigeschaltet.';

  @override
  String get newStickersButton => 'Schon die neuen Sticker gesehen?';

  @override
  String get updateButton => 'Neue Version! Aktualisieren';

  @override
  String get whatsNewLabel => 'Neuigkeiten';

  @override
  String get whatsNewOk => 'Cool!';

  @override
  String get newStickerLabel => 'Neu!';

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
  String walkTitle(String name) {
    return 'Spaziergang mit $name';
  }

  @override
  String get walkIntro =>
      'Lauf mit dem Handy in der Hand oder tippe abwechselnd auf die Füße!';

  @override
  String walkIntroTapping(String name) {
    return 'Tippe auf die Füße, um mit $name spazieren zu gehen – so schnell du willst!';
  }

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
  String walksCapped(String name) {
    return 'So viele Spaziergänge! ${name}s Akku ist leer. Morgen geht\'s weiter!';
  }

  @override
  String get muteSounds => 'Ton aus';

  @override
  String get unmuteSounds => 'Ton an';

  @override
  String get remindersButton => 'Erinnerungen';

  @override
  String remindersOffInfo(String name) {
    return '$name kann zu den Essenszeiten und wenn es aufs Klo muss eine sanfte Erinnerung schicken – nie während des Unterrichts und nie nachts. Gerade sind sie aus.';
  }

  @override
  String get remindersOnInfo =>
      'Erinnerungen sind an: ein paar am Tag, zu den Essens- und Klozeiten. Nach einem Tag ohne Spielen hören sie von selbst auf.';

  @override
  String get remindersTurnOn => 'Einschalten';

  @override
  String get remindersTurnOff => 'Ausschalten';

  @override
  String remindersDenied(String name) {
    return 'Benachrichtigungen für $name sind in den Handy-Einstellungen blockiert.';
  }

  @override
  String get remindersOpenSettings => 'Einstellungen öffnen';

  @override
  String reminderMeal(String name) {
    return 'Essenszeit! $name hätte gern etwas Leckeres.';
  }

  @override
  String reminderPotty(String name) {
    return '$name muss aufs Klo! Hilfst du?';
  }

  @override
  String get reminderChannel => 'Chigüis Tagesablauf';

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
  String tapsCapped(String name) {
    return 'Puh, puh! $name ist vom vielen Tippen ganz außer Atem. Morgen geht\'s weiter – oder lauf richtig los.';
  }

  @override
  String piggyBankFull(String name) {
    return '${name}s Sparschwein ist für heute voll! Spielen macht trotzdem Spaß.';
  }

  @override
  String get studyStatus => 'Seite um Seite! Mit dir lerne ich viel schneller.';

  @override
  String get mathTitle => 'Mathestunde';

  @override
  String mathHint(String name) {
    return '$name hat Mathe-Hausaufgaben dabei! Wähl ein Level und tipp auf die richtige Antwort. Keine Eile, Fehler sind nicht schlimm.';
  }

  @override
  String get mathLevelSums => 'Plus bis 10';

  @override
  String get mathLevelUpTo20 => 'Bis 20';

  @override
  String get mathLevelUpTo100 => 'Bis 100';

  @override
  String get mathLevelTables => 'Einmaleins';

  @override
  String get mathLevelMultiplyDivide => 'Mal und geteilt';

  @override
  String get mathLevelFractions => 'Brüche und Dezimalzahlen';

  @override
  String get mathLevelIntegers => 'Minuszahlen und Potenzen';

  @override
  String get mathLevelEquations => 'Gleichungen und %';

  @override
  String get mathTryAgain => 'Fast! Probier eine andere.';

  @override
  String mathRightFirstTime(int count, int total) {
    return '$count von $total auf Anhieb richtig!';
  }

  @override
  String get mathOf => 'von';

  @override
  String get mathTimes => '·';

  @override
  String get mathDivide => ':';

  @override
  String get mathDecimalPoint => ',';

  @override
  String mathPercent(int percent) {
    return '$percent %';
  }

  @override
  String get itemStickerPizza => 'Pizza-Sticker';

  @override
  String get itemStickerBurger => 'Burger-Sticker';

  @override
  String get itemStickerRamen => 'Ramen-Sticker';

  @override
  String get itemStickerCroissant => 'Croissant-Sticker';

  @override
  String get itemStickerCake => 'Torten-Sticker';

  @override
  String get itemStickerCookie => 'Keks-Sticker';

  @override
  String get itemStickerCocoa => 'Kakao-Sticker';

  @override
  String get itemStickerMoon => 'Mond-Sticker';

  @override
  String get itemStickerSun => 'Sonnen-Sticker';

  @override
  String get itemStickerEarth => 'Erd-Sticker';

  @override
  String get itemStickerSatellite => 'Satelliten-Sticker';

  @override
  String get itemStickerGalaxy => 'Galaxie-Sticker';

  @override
  String get itemStickerSparkles => 'Funkel-Sticker';

  @override
  String get itemStickerDpad => 'Steuerkreuz-Sticker';

  @override
  String get itemStickerRobot => 'Roboter-Sticker';

  @override
  String get itemStickerPuzzle => 'Puzzleteil-Sticker';

  @override
  String get itemStickerDice => 'Würfel-Sticker';

  @override
  String get itemStickerChip => 'Chip-Sticker';

  @override
  String get itemStickerKeyboard => 'Tastatur-Sticker';

  @override
  String get itemStickerTrophy => 'Pokal-Sticker';

  @override
  String get itemStickerLeaf => 'Blatt-Sticker';

  @override
  String get itemStickerFlower => 'Blumen-Sticker';

  @override
  String get itemStickerLotus => 'Lotus-Sticker';

  @override
  String get itemStickerDrop => 'Tropfen-Sticker';

  @override
  String get itemStickerWaves => 'Wellen-Sticker';

  @override
  String get itemStickerForest => 'Wald-Sticker';

  @override
  String get itemStickerPaw => 'Pfoten-Sticker';

  @override
  String get itemStickerBee => 'Bienen-Sticker';

  @override
  String get itemStickerPiano => 'Klavier-Sticker';

  @override
  String get itemStickerHeadphones => 'Kopfhörer-Sticker';

  @override
  String get itemStickerMic => 'Mikrofon-Sticker';

  @override
  String get itemStickerVinyl => 'Schallplatten-Sticker';

  @override
  String get itemStickerPalette => 'Farbpaletten-Sticker';

  @override
  String get itemStickerBrush => 'Pinsel-Sticker';

  @override
  String get itemStickerMasks => 'Theatermasken-Sticker';

  @override
  String get itemStickerBook => 'Buch-Sticker';

  @override
  String get itemStickerPencil => 'Bleistift-Sticker';

  @override
  String get itemStickerCalculator => 'Taschenrechner-Sticker';

  @override
  String get itemStickerFlask => 'Labor-Sticker';

  @override
  String get itemStickerIdea => 'Ideen-Sticker';

  @override
  String get itemStickerBackpack => 'Schulranzen-Sticker';

  @override
  String get itemStickerGradCap => 'Doktorhut-Sticker';

  @override
  String get itemStickerRuler => 'Geodreieck-Sticker';

  @override
  String get itemStickerRainbow => 'Regenbogen-Sticker';

  @override
  String get itemStickerCloud => 'Wolken-Sticker';

  @override
  String get itemStickerSmiley => 'Smiley-Sticker';

  @override
  String get itemStickerGift => 'Geschenk-Sticker';

  @override
  String get itemStickerParty => 'Konfetti-Sticker';

  @override
  String get itemStickerUmbrella => 'Regenschirm-Sticker';

  @override
  String get itemStickerDiamond => 'Diamant-Sticker';

  @override
  String get albumPageFood => 'Snacks';

  @override
  String get albumPageSpace => 'Weltall';

  @override
  String get albumPageGames => 'Videospiele';

  @override
  String get albumPageNature => 'Natur';

  @override
  String get albumPageMusic => 'Musik und Kunst';

  @override
  String get albumPageSchool => 'Schule';

  @override
  String get albumPageCute => 'Süßes';

  @override
  String get achievementsTitle => 'Erfolge';

  @override
  String get achievementUnlocked => 'Neuer Erfolg!';

  @override
  String get achievementWhere => 'Du findest ihn im Album.';

  @override
  String get achievementOk => 'Juhu!';

  @override
  String achievementsCount(int count, int total) {
    return '$count von $total';
  }

  @override
  String get achievementCollector => 'Der Sammler';

  @override
  String get achievementCollectorHow => 'Kauf alle Sticker im Laden.';

  @override
  String get achievementFruitMuncher => 'Obstvielfraß';

  @override
  String achievementFruitMuncherHow(int count) {
    return 'Fang $count oder mehr Früchte in einer Runde, ohne einen einzigen Stein.';
  }

  @override
  String get achievementCleanestInPond => 'Sauberster im Teich';

  @override
  String achievementCleanestInPondHow(String name) {
    return 'Bade $name, ohne ein einziges Mal das Falsche zu nehmen.';
  }

  @override
  String get achievementCapybaraEye => 'Capybara-Auge';

  @override
  String achievementCapybaraEyeHow(String name) {
    return 'Finde $name in jeder Runde beim Versteckspiel.';
  }

  @override
  String get achievementCapybaraMemory => 'Capybara-Gedächtnis';

  @override
  String get achievementCapybaraMemoryHow =>
      'Beende ein Memory, ohne ein Paar zu verpassen, das du schon gesehen hattest.';

  @override
  String get achievementMathWhiz => 'Rechenass';

  @override
  String get achievementMathWhizHow =>
      'Löse in der Mathestunde alle zehn auf Anhieb richtig.';

  @override
  String get albumPreviousPage => 'Vorherige Seite';

  @override
  String get albumNextPage => 'Nächste Seite';

  @override
  String get albumOtherPages => 'Auf anderen Seiten warten noch lose Sticker.';

  @override
  String get renameButton => 'Namen ändern';

  @override
  String renameTitle(String name) {
    return 'Wie soll $name heißen?';
  }

  @override
  String get renameField => 'Name';

  @override
  String get renameFirstFree =>
      'Der erste Name ist frei; danach kannst du ihn einmal im Monat ändern.';

  @override
  String get renameMonthly => 'Du kannst den Namen einmal im Monat ändern.';

  @override
  String get renameWait =>
      'Nächsten Monat kannst du wieder einen neuen Namen aussuchen.';

  @override
  String get renameSave => 'Speichern';

  @override
  String get renameCancel => 'Abbrechen';

  @override
  String renamedStatus(String name) {
    return 'Hmmm … $name. An diesen neuen Namen könnte ich mich gewöhnen.';
  }

  @override
  String get itemOrange => 'Orange';

  @override
  String get itemSeagull => 'Möwe';

  @override
  String get itemCrocodile => 'Krokodil';

  @override
  String get schoolStatus =>
      'Unterrichtszeit! Ich lerne fleißig, aber ein kleines Spiel wäre auch schön.';
}
