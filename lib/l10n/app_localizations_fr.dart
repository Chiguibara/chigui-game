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
  String get tapHint => 'Touche Chigüi pour dire bonjour';

  @override
  String get petAction => 'caresser Chigüi';

  @override
  String get lovedStatus => 'Chigüi est aux anges !';

  @override
  String get pettedLowStatus => 'Chigüi a adoré ! Encore un câlin ?';

  @override
  String get pettedMidStatus => 'Que c\'est doux ! Encore un peu ?';

  @override
  String get ateStatus => 'Miam ! Merci !';

  @override
  String get fullStatus => 'Chigüi n\'a plus faim pour l\'instant';

  @override
  String get wantsFood => 'Chigüi grignoterait bien quelque chose';

  @override
  String get wantsAffection => 'Chigüi aimerait bien des câlins';

  @override
  String get wantsFun => 'Chigüi a envie de jouer';

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
  String get bedButton => 'Au lit';

  @override
  String get vetButton => 'Chez le véto';

  @override
  String get cleanAction => 'nettoyer';

  @override
  String get asleepStatus => 'Chut… Chigüi dort';

  @override
  String get sickStatus => 'Chigüi ne se sent pas bien. Direction le véto !';

  @override
  String get pottyStatus => 'Chigüi doit aller aux toilettes !';

  @override
  String get sleepyStatus => 'Chigüi a sommeil';

  @override
  String get mealtimeStatus => 'C\'est l\'heure de manger !';

  @override
  String get grumpyStatus =>
      'Personne n\'a couché Chigüi, alors Chigüi boude. Un câlin et ça passe !';

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
  String get minigameHint => 'Fais glisser Chigüi pour attraper les fruits !';

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
  String coinsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count pièces',
      one: '+1 pièce',
      zero: 'Chigüi a passé un bon moment quand même !',
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
  String get chompSound => 'Miam !';

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
  String get shopTitle => 'La boutique de Chigüi';

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
  String get stickerBoughtStatus => 'Autocollant ajouté à ton album !';

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
  String get walkTitle => 'Balade avec Chigüi';

  @override
  String get walkIntro =>
      'Marche avec le téléphone en main, ou touche les pieds l\'un après l\'autre !';

  @override
  String get walkIntroTapping =>
      'Touche les pieds l\'un après l\'autre pour te balader avec Chigüi !';

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
  String get otherFoot => 'L\'autre pied !';

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
  String get walksCapped =>
      'Que de balades ! Chigüi n\'a plus de batterie. La suite demain !';

  @override
  String get muteSounds => 'Couper le son';

  @override
  String get unmuteSounds => 'Activer le son';

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
  String get tapsCapped =>
      'Les pattes de Chigüi sont fatiguées de tapoter ! La suite demain, ou marche pour de vrai.';
}
