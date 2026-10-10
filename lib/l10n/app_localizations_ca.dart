// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Chigüi';

  @override
  String get chiguiName => 'Chigüi';

  @override
  String get tapHint => 'Toca Chigüi per saludar';

  @override
  String get petAction => 'acariciar Chigüi';

  @override
  String get lovedStatus => 'Quina alegria té Chigüi!';

  @override
  String get pettedLowStatus =>
      'Això li ha agradat! Unes quantes moixaines més?';

  @override
  String get pettedMidStatus => 'Quin gustet! Una mica més?';

  @override
  String get ateStatus => 'Nyam! Gràcies!';

  @override
  String get fullStatus => 'Chigüi ja ha menjat prou de moment';

  @override
  String get wantsFood => 'A Chigüi li ve de gust fer un mos';

  @override
  String get wantsAffection => 'A Chigüi li vindrien de gust unes moixaines';

  @override
  String get wantsFun => 'Chigüi té ganes de jugar';

  @override
  String get feedButton => 'Donar menjar';

  @override
  String get needFood => 'Menjar';

  @override
  String get needAffection => 'Afecte';

  @override
  String get needFun => 'Diversió';

  @override
  String needMeterLabel(String need, int percent) {
    return '$need: $percent %';
  }

  @override
  String get toiletButton => 'Al lavabo';

  @override
  String get bedButton => 'A dormir';

  @override
  String get vetButton => 'Al veterinari';

  @override
  String get cleanAction => 'netejar';

  @override
  String get asleepStatus => 'Xxxt… Chigüi dorm';

  @override
  String get sickStatus => 'Chigüi no es troba bé. Cap al veterinari!';

  @override
  String get pottyStatus => 'Chigüi ha d\'anar al lavabo!';

  @override
  String get sleepyStatus => 'Chigüi té son';

  @override
  String get mealtimeStatus => 'És l\'hora de menjar!';

  @override
  String get grumpyStatus =>
      'Ningú no va acotxar Chigüi i fa morros. Unes moixaines i se li passa!';

  @override
  String get messStatus => 'Fa una olor estranya… Toca netejar!';

  @override
  String get reliefStatus => 'Uf, quin descans!';

  @override
  String get curedStatus => 'Ja està! Quin valor!';

  @override
  String get cleanedStatus => 'Tot net!';

  @override
  String get playButton => 'Jugar';

  @override
  String coinsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count monedes',
      one: '1 moneda',
    );
    return '$_temp0';
  }

  @override
  String get minigameTitle => 'Atrapa la fruita';

  @override
  String get minigameHint => 'Arrossega per moure Chigüi i atrapar la fruita!';

  @override
  String get startButton => 'A jugar!';

  @override
  String secondsLeft(int seconds) {
    return '$seconds s';
  }

  @override
  String fruitsCaught(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fruites atrapades',
      one: '1 fruita atrapada',
      zero: 'Aquesta vegada no hi ha hagut fruita',
    );
    return '$_temp0';
  }

  @override
  String coinsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count monedes',
      one: '+1 moneda',
      zero: 'Chigüi s\'ho ha passat bé igualment!',
    );
    return '$_temp0';
  }

  @override
  String get roundDone => 'Bona partida!';

  @override
  String get playAgainButton => 'Una altra';

  @override
  String get backHomeButton => 'Tornar';

  @override
  String get chompSound => 'Nyam!';

  @override
  String get walkedStatus => 'Quin passeig més bonic!';

  @override
  String stepsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passos avui',
      one: '1 pas avui',
    );
    return '$_temp0';
  }

  @override
  String get shopButton => 'Botiga';

  @override
  String get shopTitle => 'La botiga de Chigüi';

  @override
  String get shopHint => 'Què ens emportem avui?';

  @override
  String get seasonalSection => 'De temporada';

  @override
  String get accessoriesSection => 'Accessoris';

  @override
  String get stickersSection => 'Adhesius';

  @override
  String get wearButton => 'Posar-s\'ho';

  @override
  String get takeOffButton => 'Treure-s\'ho';

  @override
  String get inAlbum => 'Al teu àlbum';

  @override
  String get boughtStatus => 'Nou look desbloquejat!';

  @override
  String get stickerBoughtStatus => 'Adhesiu afegit al teu àlbum!';

  @override
  String notEnoughCoins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Error 402: falten $count monedes. Unes quantes partides d\'Atrapa la fruita i arreglat!',
      one:
          'Error 402: falta 1 moneda. Una partida d\'Atrapa la fruita i arreglat!',
    );
    return '$_temp0';
  }

  @override
  String get seasonSpooktober => 'Halloween';

  @override
  String get seasonChristmas => 'Nadal';

  @override
  String get seasonSpring => 'Primavera';

  @override
  String get seasonSummer => 'Estiu';

  @override
  String get backSpooktober => 'Torna cada octubre';

  @override
  String get backChristmas => 'Torna cada Nadal';

  @override
  String get backSpring => 'Torna cada primavera';

  @override
  String get backSummer => 'Torna cada estiu';

  @override
  String get tooEarlySpooktober =>
      'Els fantasmes encara ronquen a la seva cripta. Torna a l\'octubre!';

  @override
  String get tooEarlyChristmas =>
      'Els follets del Pare Noel encara estan compilant els regals. Torna al desembre!';

  @override
  String get tooEarlySpring =>
      'Les flors encara són en fase beta. Torna a la primavera!';

  @override
  String get tooEarlySummer =>
      'La platja encara s\'està carregant… 42 %. Torna a l\'estiu!';

  @override
  String get itemGeekGlasses => 'Ulleres de friqui';

  @override
  String get itemBeanie => 'Gorret de llana';

  @override
  String get itemScarf => 'Bufanda';

  @override
  String get itemHeadphones => 'Auriculars';

  @override
  String get itemGhost => 'Disfressa de fantasma';

  @override
  String get itemPumpkin => 'Carbassa';

  @override
  String get itemSantaHat => 'Barret de Pare Noel';

  @override
  String get itemXmasTree => 'Arbre de Nadal';

  @override
  String get itemFlowerCrown => 'Corona de flors';

  @override
  String get itemButterfly => 'Papallona amiga';

  @override
  String get itemSurfboard => 'Taula de surf';

  @override
  String get itemSnorkel => 'Ulleres de busseig amb tub';

  @override
  String get itemStickerStar => 'Adhesiu d\'estrella';

  @override
  String get itemStickerHeart => 'Adhesiu de cor';

  @override
  String get itemStickerRocket => 'Adhesiu de coet';

  @override
  String get itemStickerGamepad => 'Adhesiu de comandament';

  @override
  String get itemStickerMusic => 'Adhesiu de música';

  @override
  String get itemStickerIceCream => 'Adhesiu de gelat';

  @override
  String get walkButton => 'Passejar';

  @override
  String get walkTitle => 'De passeig amb Chigüi';

  @override
  String get walkIntro =>
      'Camina amb el mòbil a la mà o toca els peus l\'un darrere l\'altre!';

  @override
  String get walkIntroTapping =>
      'Toca els peus l\'un darrere l\'altre per passejar amb Chigüi!';

  @override
  String get startWalkButton => 'Som-hi!';

  @override
  String get sensorWalkHint => 'Camina amb el mòbil a la mà o toca els peus!';

  @override
  String get pedometerWalkHint =>
      'Camina de debò (encara que portis el mòbil a la butxaca) o toca els peus!';

  @override
  String get tapFeetHint => 'Esquerre, dret, esquerre, dret…';

  @override
  String get otherFoot => 'L\'altre peu!';

  @override
  String get leftFoot => 'peu esquerre';

  @override
  String get rightFoot => 'peu dret';

  @override
  String nextWalkProgress(int steps, int goal) {
    return '$steps de $goal passos per al proper passeig';
  }

  @override
  String walksToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count passejos avui',
      one: '1 passeig avui',
    );
    return '$_temp0';
  }

  @override
  String get walksCapped =>
      'Quants passejos! A Chigüi se li han gastat les piles. Demà més!';

  @override
  String get muteSounds => 'Silenciar els sons';

  @override
  String get unmuteSounds => 'Activar els sons';

  @override
  String get packsSection => 'Paquets';

  @override
  String get packGeekName => 'Paquet friqui';

  @override
  String get packSweetName => 'Paquet dolç';

  @override
  String get packOwned => 'És teu!';

  @override
  String get packWaiting => 'Esperant que un adult ho aprovi…';

  @override
  String get buyPackTitle => 'Això costa diners de debò';

  @override
  String get buyPackBody =>
      'Pregunta-ho abans a un adult. La botiga li demanarà que ho confirmi i ho pagui.';

  @override
  String get buyPackConfirm => 'Continuar al pagament';

  @override
  String get buyPackCancel => 'Ara no';

  @override
  String get packBoughtStatus => 'Paquet desbloquejat! Mira\'l a Accessoris.';

  @override
  String get packErrorStatus =>
      'La compra no s\'ha completat. Torna-ho a provar més tard.';

  @override
  String get itemPixelGlasses => 'Ulleres pixelades';

  @override
  String get itemWizardHat => 'Barret de mag';

  @override
  String get itemLaptop => 'Portàtil amb adhesius';

  @override
  String get itemBunnyEars => 'Orelles de conill';

  @override
  String get itemHeartGlasses => 'Ulleres de cor';

  @override
  String get itemCupcake => 'Magdalena';

  @override
  String get itemCap => 'Gorra';

  @override
  String get itemVikingHelmet => 'Casc víking';

  @override
  String get itemCrown => 'Corona';

  @override
  String get itemMustache => 'Bigoti';

  @override
  String get itemGlasses3d => 'Ulleres 3D';

  @override
  String get itemBandana => 'Mocador';

  @override
  String get itemMedal => 'Medalla';

  @override
  String get itemCape => 'Capa de superheroi';

  @override
  String get itemBalloon => 'Globus de cor';

  @override
  String get itemSkateboard => 'Monopatí';

  @override
  String get itemRetroConsole => 'Consola retro';
}
