// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Chigüi';

  @override
  String get chiguiName => 'Chigüi';

  @override
  String tapHint(String name) {
    return 'Touche $name pour dire bonjour';
  }

  @override
  String petAction(String name) {
    return 'caresser $name';
  }

  @override
  String lovedStatus(String name) {
    return '$name est aux anges !';
  }

  @override
  String pettedLowStatus(String name) {
    return '$name a adoré ! Encore un câlin ?';
  }

  @override
  String get pettedMidStatus => 'Que c\'est doux ! Encore un peu ?';

  @override
  String get ateStatus => 'Miam ! Merci !';

  @override
  String fullStatus(String name) {
    return '$name n\'a plus faim pour l\'instant';
  }

  @override
  String wantsFood(String name) {
    return '$name grignoterait bien quelque chose';
  }

  @override
  String wantsAffection(String name) {
    return '$name aimerait bien des câlins';
  }

  @override
  String wantsFun(String name) {
    return '$name a envie de jouer';
  }

  @override
  String get feedButton => 'Nourrir';

  @override
  String get needFood => 'Nourriture';

  @override
  String get needAffection => 'Tendresse';

  @override
  String get needFun => 'Amusement';

  @override
  String needMeterLabel(String need, int percent) {
    return '$need : $percent %';
  }

  @override
  String get toiletButton => 'Aux toilettes';

  @override
  String get vetButton => 'Chez le véto';

  @override
  String get cleanAction => 'nettoyer';

  @override
  String asleepStatus(String name) {
    return 'Chut… $name dort';
  }

  @override
  String sickStatus(String name) {
    return '$name ne se sent pas bien. Direction le véto !';
  }

  @override
  String pottyStatus(String name) {
    return '$name doit aller aux toilettes !';
  }

  @override
  String sleepyStatus(String name) {
    return '$name a sommeil';
  }

  @override
  String get mealtimeStatus => 'C\'est l\'heure de manger !';

  @override
  String yawnStatus(String name) {
    return 'Ouaaah… $name se réveille !';
  }

  @override
  String get messStatus => 'Ça sent bizarre… On nettoie !';

  @override
  String get reliefStatus => 'Ouf, ça va mieux !';

  @override
  String get curedStatus => 'C\'est fini ! Quel courage !';

  @override
  String get cleanedStatus => 'Tout propre !';

  @override
  String get playButton => 'Jouer';

  @override
  String coinsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pièces',
      one: '1 pièce',
    );
    return '$_temp0';
  }

  @override
  String get minigameTitle => 'Attrape les fruits';

  @override
  String minigameHint(String name) {
    return 'Fais glisser $name : attrape les fruits et évite les cailloux !';
  }

  @override
  String get arrowKeysHint =>
      'Sur ordinateur, les flèches du clavier marchent aussi.';

  @override
  String get startButton => 'C\'est parti !';

  @override
  String secondsLeft(int seconds) {
    return '$seconds s';
  }

  @override
  String fruitsCaught(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fruits attrapés',
      one: '1 fruit attrapé',
      zero: 'Pas de fruit cette fois',
    );
    return '$_temp0';
  }

  @override
  String coinsEarned(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count pièces',
      one: '+1 pièce',
      zero: '$name a passé un bon moment quand même !',
    );
    return '$_temp0';
  }

  @override
  String get roundDone => 'Belle partie !';

  @override
  String get playAgainButton => 'Rejouer';

  @override
  String get backHomeButton => 'Retour';

  @override
  String get otherGamesButton => 'Autres jeux';

  @override
  String get gamesTitle => 'On joue à quoi ?';

  @override
  String get memoryTitle => 'Memory des fruits';

  @override
  String get memoryHint =>
      'Retourne deux cartes à la fois et trouve toutes les paires !';

  @override
  String cardsCount(int count) {
    return '$count cartes';
  }

  @override
  String get memoryCard => 'Carte';

  @override
  String pairsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paires trouvées',
      one: '1 paire trouvée',
    );
    return '$_temp0';
  }

  @override
  String get hideTitle => 'Cache-cache';

  @override
  String hideHint(String name) {
    return '$name se cache sous une boîte, puis les boîtes bougent. Ne la quitte pas des yeux !';
  }

  @override
  String hideWatch(String name) {
    return 'Suis bien la boîte de $name…';
  }

  @override
  String hidePick(String name) {
    return 'Où est $name ?';
  }

  @override
  String get hideFound => 'Bravo, j\'étais là !';

  @override
  String get hideMissed => 'Coucou ! J\'étais par ici !';

  @override
  String hideBox(int number) {
    return 'Boîte $number';
  }

  @override
  String timesFound(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tu as trouvé $name $count fois',
      one: 'Tu as trouvé $name 1 fois',
      zero: '$name se cache à merveille !',
    );
    return '$_temp0';
  }

  @override
  String get bathTitle => 'Petit bain';

  @override
  String bathHint(String name) {
    return '$name s\'en est mis partout en jouant ! Mets $name dans le baquet, puis choisis les bons objets pour enlever les taches collantes.';
  }

  @override
  String bathArrive(String name) {
    return 'Voilà $name, du goudron jusqu\'aux oreilles !';
  }

  @override
  String bathHopIn(String name) {
    return 'Touche $name, et hop, dans le baquet !';
  }

  @override
  String get bathWash => 'Choisis un objet et nettoie les taches collantes';

  @override
  String get bathYuzu => 'Plus une tache ! Lance quelques yuzus dans l\'eau';

  @override
  String get bathSoak => 'Ahhh… un bon bain au yuzu';

  @override
  String bathDry(String name) {
    return 'Hors de l\'eau ! Sèche $name avec la serviette';
  }

  @override
  String get bathDone => 'Que de douceur et quel éclat !';

  @override
  String bathSpots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taches collantes en moins',
      one: '1 tache collante en moins',
    );
    return '$_temp0';
  }

  @override
  String get bathToolSoap => 'Savon';

  @override
  String get bathToolBrush => 'Brosse';

  @override
  String get bathToolLadle => 'Louche';

  @override
  String get bathToolYuzu => 'Yuzu';

  @override
  String get bathToolTowel => 'Serviette';

  @override
  String get chompSound => 'Miam !';

  @override
  String get ouchSound => 'Aïe !';

  @override
  String get walkedStatus => 'Quelle belle promenade !';

  @override
  String stepsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pas aujourd\'hui',
      one: '1 pas aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String get shopButton => 'Boutique';

  @override
  String shopTitle(String name) {
    return 'La boutique de $name';
  }

  @override
  String get shopHint => 'On prend quoi aujourd\'hui ?';

  @override
  String get seasonalSection => 'De saison';

  @override
  String get accessoriesSection => 'Accessoires';

  @override
  String get stickersSection => 'Autocollants';

  @override
  String get wearButton => 'Porter';

  @override
  String get takeOffButton => 'Enlever';

  @override
  String get inAlbum => 'Dans ton album';

  @override
  String get boughtStatus => 'Nouveau look débloqué !';

  @override
  String get stickerBoughtStatus =>
      'Nouvel autocollant ! Colle-le dans ton album.';

  @override
  String get albumButton => 'Album d\'autocollants';

  @override
  String albumTitle(String name) {
    return 'L\'album de $name';
  }

  @override
  String get albumHint => 'Fais glisser chaque autocollant à sa place';

  @override
  String get albumEmpty =>
      'Pas encore d\'autocollants. Achète-les à la boutique avec tes pièces !';

  @override
  String get albumStuck => 'Collé ! Trop beau.';

  @override
  String get albumAllStuck =>
      'Tous collés ! Il y en a d\'autres à la boutique.';

  @override
  String get albumComplete => 'Album complet ! Succès débloqué à 100 %.';

  @override
  String get newStickersButton => 'Tu as vu les nouveaux autocollants ?';

  @override
  String get updateButton => 'Nouvelle version ! Mettre à jour';

  @override
  String get whatsNewLabel => 'Nouveautés';

  @override
  String get whatsNewOk => 'Super !';

  @override
  String get newStickerLabel => 'Nouveau !';

  @override
  String notEnoughCoins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Erreur 402 : il manque $count pièces. Quelques parties d\'Attrape les fruits et c\'est réglé !',
      one:
          'Erreur 402 : il manque 1 pièce. Une partie d\'Attrape les fruits et c\'est réglé !',
    );
    return '$_temp0';
  }

  @override
  String get seasonSpooktober => 'Halloween';

  @override
  String get seasonChristmas => 'Noël';

  @override
  String get seasonSpring => 'Printemps';

  @override
  String get seasonSummer => 'Été';

  @override
  String get backSpooktober => 'Revient chaque octobre';

  @override
  String get backChristmas => 'Revient chaque Noël';

  @override
  String get backSpring => 'Revient chaque printemps';

  @override
  String get backSummer => 'Revient chaque été';

  @override
  String get tooEarlySpooktober =>
      'Les fantômes ronflent encore dans leur crypte. Reviens en octobre !';

  @override
  String get tooEarlyChristmas =>
      'Les lutins du père Noël compilent encore les cadeaux. Reviens en décembre !';

  @override
  String get tooEarlySpring =>
      'Les fleurs sont encore en bêta. Reviens au printemps !';

  @override
  String get tooEarlySummer =>
      'La plage est en cours de chargement… 42 %. Reviens en été !';

  @override
  String get itemGeekGlasses => 'Lunettes de geek';

  @override
  String get itemBeanie => 'Bonnet en laine';

  @override
  String get itemScarf => 'Écharpe';

  @override
  String get itemHeadphones => 'Casque audio';

  @override
  String get itemGhost => 'Costume de fantôme';

  @override
  String get itemPumpkin => 'Citrouille';

  @override
  String get itemSantaHat => 'Bonnet de père Noël';

  @override
  String get itemXmasTree => 'Sapin de Noël';

  @override
  String get itemFlowerCrown => 'Couronne de fleurs';

  @override
  String get itemButterfly => 'Papillon ami';

  @override
  String get itemSurfboard => 'Planche de surf';

  @override
  String get itemSnorkel => 'Masque et tuba';

  @override
  String get itemStickerStar => 'Autocollant étoile';

  @override
  String get itemStickerHeart => 'Autocollant cœur';

  @override
  String get itemStickerRocket => 'Autocollant fusée';

  @override
  String get itemStickerGamepad => 'Autocollant manette';

  @override
  String get itemStickerMusic => 'Autocollant musique';

  @override
  String get itemStickerIceCream => 'Autocollant glace';

  @override
  String get walkButton => 'Promener';

  @override
  String walkTitle(String name) {
    return 'Balade avec $name';
  }

  @override
  String get walkIntro =>
      'Marche avec le téléphone en main, ou touche les pieds l\'un après l\'autre !';

  @override
  String walkIntroTapping(String name) {
    return 'Touche les pieds pour te balader avec $name, aussi vite que tu veux !';
  }

  @override
  String get startWalkButton => 'On y va !';

  @override
  String get sensorWalkHint =>
      'Marche avec le téléphone en main, ou touche les pieds !';

  @override
  String get pedometerWalkHint =>
      'Marche pour de vrai (même avec le téléphone dans la poche), ou touche les pieds !';

  @override
  String get tapFeetHint => 'Gauche, droite, gauche, droite…';

  @override
  String get leftFoot => 'pied gauche';

  @override
  String get rightFoot => 'pied droit';

  @override
  String nextWalkProgress(int steps, int goal) {
    return '$steps sur $goal pas avant la prochaine balade';
  }

  @override
  String walksToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count balades aujourd\'hui',
      one: '1 balade aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String walksCapped(String name) {
    return 'Que de balades ! $name n\'a plus de batterie. La suite demain !';
  }

  @override
  String get muteSounds => 'Couper le son';

  @override
  String get unmuteSounds => 'Activer le son';

  @override
  String get remindersButton => 'Rappels';

  @override
  String remindersOffInfo(String name) {
    return '$name peut envoyer un petit rappel à l\'heure des repas et quand c\'est l\'heure du petit coin, jamais pendant la classe ni la nuit. Ils sont désactivés pour l\'instant.';
  }

  @override
  String get remindersOnInfo =>
      'Les rappels sont activés : quelques-uns par jour, à l\'heure des repas et du petit coin. Ils s\'arrêtent tout seuls après une journée sans jouer.';

  @override
  String get remindersTurnOn => 'Activer';

  @override
  String get remindersTurnOff => 'Désactiver';

  @override
  String remindersDenied(String name) {
    return 'Les notifications de $name sont bloquées dans les réglages du téléphone.';
  }

  @override
  String get remindersOpenSettings => 'Ouvrir les réglages';

  @override
  String reminderMeal(String name) {
    return 'C\'est l\'heure du repas ! $name a envie de quelque chose de bon.';
  }

  @override
  String reminderPotty(String name) {
    return '$name doit aller au petit coin ! Tu donnes un coup de main ?';
  }

  @override
  String get reminderChannel => 'La routine de Chigüi';

  @override
  String get packsSection => 'Packs';

  @override
  String get packGeekName => 'Pack geek';

  @override
  String get packSweetName => 'Pack gourmand';

  @override
  String get packOwned => 'À toi !';

  @override
  String get packWaiting => 'En attente de l\'accord d\'un adulte…';

  @override
  String get buyPackTitle => 'Ça coûte de l\'argent pour de vrai';

  @override
  String get buyPackBody =>
      'Demande d\'abord à un adulte. La boutique lui demandera de confirmer et de payer.';

  @override
  String get buyPackConfirm => 'Continuer vers le paiement';

  @override
  String get buyPackCancel => 'Pas maintenant';

  @override
  String get packBoughtStatus =>
      'Nouveau pack débloqué ! Regarde dans Accessoires.';

  @override
  String get packErrorStatus => 'L\'achat n\'a pas abouti. Réessaie plus tard.';

  @override
  String get itemPixelGlasses => 'Lunettes pixelisées';

  @override
  String get itemWizardHat => 'Chapeau de magicien';

  @override
  String get itemLaptop => 'Ordinateur avec autocollants';

  @override
  String get itemBunnyEars => 'Oreilles de lapin';

  @override
  String get itemHeartGlasses => 'Lunettes cœur';

  @override
  String get itemCupcake => 'Cupcake';

  @override
  String get itemCap => 'Casquette';

  @override
  String get itemVikingHelmet => 'Casque de viking';

  @override
  String get itemCrown => 'Couronne';

  @override
  String get itemMustache => 'Moustache';

  @override
  String get itemGlasses3d => 'Lunettes 3D';

  @override
  String get itemBandana => 'Bandana';

  @override
  String get itemMedal => 'Médaille';

  @override
  String get itemCape => 'Cape de super-héros';

  @override
  String get itemBalloon => 'Ballon cœur';

  @override
  String get itemSkateboard => 'Skateboard';

  @override
  String get itemRetroConsole => 'Console rétro';

  @override
  String tapsCapped(String name) {
    return 'Pff, pff ! $name est à bout de souffle à force de tapoter. La suite demain, ou marche pour de vrai.';
  }

  @override
  String piggyBankFull(String name) {
    return 'La tirelire de $name est pleine pour aujourd\'hui ! Jouer reste amusant.';
  }

  @override
  String get studyStatus => 'Page après page ! Avec toi, j\'étudie plus vite.';

  @override
  String get mathTitle => 'Cours de maths';

  @override
  String mathHint(String name) {
    return '$name a des devoirs de maths ! Choisis un niveau et touche la bonne réponse. Prends ton temps, se tromper n\'est pas grave.';
  }

  @override
  String get mathLevelSums => 'Additions jusqu\'à 10';

  @override
  String get mathLevelUpTo20 => 'Jusqu\'à 20';

  @override
  String get mathLevelUpTo100 => 'Jusqu\'à 100';

  @override
  String get mathLevelTables => 'Tables de multiplication';

  @override
  String get mathLevelMultiplyDivide => 'Multiplier et diviser';

  @override
  String get mathLevelFractions => 'Fractions et décimaux';

  @override
  String get mathLevelIntegers => 'Négatifs et puissances';

  @override
  String get mathLevelEquations => 'Équations et %';

  @override
  String get mathTryAgain => 'Presque ! Essaie une autre.';

  @override
  String mathRightFirstTime(int count, int total) {
    return '$count sur $total du premier coup !';
  }

  @override
  String get mathOf => 'de';

  @override
  String get mathTimes => '×';

  @override
  String get mathDivide => '÷';

  @override
  String get mathDecimalPoint => ',';

  @override
  String mathPercent(int percent) {
    return '$percent %';
  }

  @override
  String get itemStickerPizza => 'Autocollant pizza';

  @override
  String get itemStickerBurger => 'Autocollant burger';

  @override
  String get itemStickerRamen => 'Autocollant ramen';

  @override
  String get itemStickerCroissant => 'Autocollant croissant';

  @override
  String get itemStickerCake => 'Autocollant gâteau';

  @override
  String get itemStickerCookie => 'Autocollant cookie';

  @override
  String get itemStickerCocoa => 'Autocollant chocolat chaud';

  @override
  String get itemStickerMoon => 'Autocollant lune';

  @override
  String get itemStickerSun => 'Autocollant soleil';

  @override
  String get itemStickerEarth => 'Autocollant Terre';

  @override
  String get itemStickerSatellite => 'Autocollant satellite';

  @override
  String get itemStickerGalaxy => 'Autocollant galaxie';

  @override
  String get itemStickerSparkles => 'Autocollant étincelles';

  @override
  String get itemStickerDpad => 'Autocollant croix directionnelle';

  @override
  String get itemStickerRobot => 'Autocollant robot';

  @override
  String get itemStickerPuzzle => 'Autocollant pièce de puzzle';

  @override
  String get itemStickerDice => 'Autocollant dé';

  @override
  String get itemStickerChip => 'Autocollant puce';

  @override
  String get itemStickerKeyboard => 'Autocollant clavier';

  @override
  String get itemStickerTrophy => 'Autocollant trophée';

  @override
  String get itemStickerLeaf => 'Autocollant feuille';

  @override
  String get itemStickerFlower => 'Autocollant fleur';

  @override
  String get itemStickerLotus => 'Autocollant lotus';

  @override
  String get itemStickerDrop => 'Autocollant goutte';

  @override
  String get itemStickerWaves => 'Autocollant vagues';

  @override
  String get itemStickerForest => 'Autocollant forêt';

  @override
  String get itemStickerPaw => 'Autocollant empreinte';

  @override
  String get itemStickerBee => 'Autocollant abeille';

  @override
  String get itemStickerPiano => 'Autocollant piano';

  @override
  String get itemStickerHeadphones => 'Autocollant casque';

  @override
  String get itemStickerMic => 'Autocollant micro';

  @override
  String get itemStickerVinyl => 'Autocollant vinyle';

  @override
  String get itemStickerPalette => 'Autocollant palette';

  @override
  String get itemStickerBrush => 'Autocollant pinceau';

  @override
  String get itemStickerMasks => 'Autocollant masques';

  @override
  String get itemStickerBook => 'Autocollant livre';

  @override
  String get itemStickerPencil => 'Autocollant crayon';

  @override
  String get itemStickerCalculator => 'Autocollant calculatrice';

  @override
  String get itemStickerFlask => 'Autocollant science';

  @override
  String get itemStickerIdea => 'Autocollant idée';

  @override
  String get itemStickerBackpack => 'Autocollant cartable';

  @override
  String get itemStickerGradCap => 'Autocollant toque';

  @override
  String get itemStickerRuler => 'Autocollant équerre';

  @override
  String get itemStickerRainbow => 'Autocollant arc-en-ciel';

  @override
  String get itemStickerCloud => 'Autocollant nuage';

  @override
  String get itemStickerSmiley => 'Autocollant smiley';

  @override
  String get itemStickerGift => 'Autocollant cadeau';

  @override
  String get itemStickerParty => 'Autocollant confettis';

  @override
  String get itemStickerUmbrella => 'Autocollant parapluie';

  @override
  String get itemStickerDiamond => 'Autocollant diamant';

  @override
  String get albumPageFood => 'Goûters';

  @override
  String get albumPageSpace => 'Espace';

  @override
  String get albumPageGames => 'Jeux vidéo';

  @override
  String get albumPageNature => 'Nature';

  @override
  String get albumPageMusic => 'Musique et art';

  @override
  String get albumPageSchool => 'École';

  @override
  String get albumPageCute => 'Trucs mignons';

  @override
  String get achievementsTitle => 'Succès';

  @override
  String get achievementUnlocked => 'Nouveau succès !';

  @override
  String get achievementWhere => 'Tu le trouveras dans l\'album.';

  @override
  String get achievementOk => 'Youpi !';

  @override
  String achievementsCount(int count, int total) {
    return '$count sur $total';
  }

  @override
  String get achievementCollector => 'Le collectionneur';

  @override
  String get achievementCollectorHow =>
      'Achète tous les autocollants de la boutique.';

  @override
  String get achievementFruitMuncher => 'Croque-fruits';

  @override
  String achievementFruitMuncherHow(int count) {
    return 'Attrape $count fruits ou plus en une partie sans prendre une seule pierre.';
  }

  @override
  String get achievementCleanestInPond => 'Le plus propre de la mare';

  @override
  String achievementCleanestInPondHow(String name) {
    return 'Donne à $name un bain entier sans jamais choisir le mauvais objet.';
  }

  @override
  String get achievementCapybaraEye => 'Œil de capybara';

  @override
  String achievementCapybaraEyeHow(String name) {
    return 'Trouve $name à chaque tour de cache-cache.';
  }

  @override
  String get achievementCapybaraMemory => 'Mémoire de capybara';

  @override
  String get achievementCapybaraMemoryHow =>
      'Termine un memory sans rater une paire que tu avais déjà vue.';

  @override
  String get achievementMathWhiz => 'Petit génie';

  @override
  String get achievementMathWhizHow =>
      'Réussis les dix du premier coup en cours de maths.';

  @override
  String get albumPreviousPage => 'Page précédente';

  @override
  String get albumNextPage => 'Page suivante';

  @override
  String get albumOtherPages =>
      'D\'autres autocollants t\'attendent sur d\'autres pages.';

  @override
  String get renameButton => 'Changer le nom';

  @override
  String renameTitle(String name) {
    return 'Comment appeler $name ?';
  }

  @override
  String get renameField => 'Nom';

  @override
  String get renameFirstFree =>
      'Ce premier nom est offert ; ensuite, tu pourras le changer une fois par mois.';

  @override
  String get renameMonthly => 'Tu peux changer le nom une fois par mois.';

  @override
  String get renameWait =>
      'Tu pourras choisir un nouveau nom le mois prochain.';

  @override
  String get renameSave => 'Enregistrer';

  @override
  String get renameCancel => 'Annuler';

  @override
  String renamedStatus(String name) {
    return 'Hmmm… $name. Je crois que je pourrais m\'habituer à ce nouveau nom.';
  }

  @override
  String get itemOrange => 'Orange';

  @override
  String get itemSeagull => 'Mouette';

  @override
  String get itemCrocodile => 'Crocodile';

  @override
  String get schoolStatus =>
      'C\'est l\'heure de la classe ! J\'étudie dur, mais un petit jeu me ferait plaisir aussi.';
}
