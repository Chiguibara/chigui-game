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
  String get yawnStatus => 'Uaaah… Chigüi s\'ha despertat!';

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
  String get minigameHint =>
      'Arrossega per moure Chigüi: atrapa la fruita i esquiva les pedres!';

  @override
  String get arrowKeysHint =>
      'A l\'ordinador també pots fer servir les fletxes.';

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
  String get otherGamesButton => 'Altres jocs';

  @override
  String get gamesTitle => 'A què juguem?';

  @override
  String get memoryTitle => 'Memory de fruites';

  @override
  String get memoryHint =>
      'Gira dues cartes cada vegada i troba totes les parelles!';

  @override
  String cardsCount(int count) {
    return '$count cartes';
  }

  @override
  String get memoryCard => 'Carta';

  @override
  String pairsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parelles trobades',
      one: '1 parella trobada',
    );
    return '$_temp0';
  }

  @override
  String get hideTitle => 'Fet i amagar';

  @override
  String get hideHint =>
      'Chigüi s\'amaga sota una caixa i després les caixes es mouen. No la perdis de vista!';

  @override
  String get hideWatch => 'No perdis de vista la caixa de Chigüi…';

  @override
  String get hidePick => 'On és Chigüi?';

  @override
  String get hideFound => 'M\'has trobat!';

  @override
  String get hideMissed => 'Cucut! Era aquí!';

  @override
  String hideBox(int number) {
    return 'Caixa $number';
  }

  @override
  String timesFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has trobat Chigüi $count vegades',
      one: 'Has trobat Chigüi 1 vegada',
      zero: 'Chigüi s\'amaga de meravella!',
    );
    return '$_temp0';
  }

  @override
  String get bathTitle => 'Banyet';

  @override
  String get bathHint =>
      'Chigüi s\'ha empastifat jugant! Posa Chigüi al cossi i tria les coses adequades per treure les taques enganxoses.';

  @override
  String get bathArrive => 'Aquí arriba Chigüi, amb quitrà fins a les orelles!';

  @override
  String get bathHopIn => 'Toca Chigüi i cap al cossi!';

  @override
  String get bathWash => 'Tria alguna cosa i neteja les taques enganxoses';

  @override
  String get bathYuzu => 'Ni una taca! Tira uns quants yuzus a l\'aigua';

  @override
  String get bathSoak => 'Ahhh… un banyet de yuzu, quin gust';

  @override
  String get bathDry => 'Fora de l\'aigua! Eixuga Chigüi amb la tovallola';

  @override
  String get bathDone => 'Quina suavitat i quina brillantor!';

  @override
  String bathSpots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count taques enganxoses fora',
      one: '1 taca enganxosa fora',
    );
    return '$_temp0';
  }

  @override
  String get bathToolSoap => 'Sabó';

  @override
  String get bathToolBrush => 'Raspall';

  @override
  String get bathToolLadle => 'Cassó d\'aigua';

  @override
  String get bathToolYuzu => 'Yuzu';

  @override
  String get bathToolTowel => 'Tovallola';

  @override
  String get chompSound => 'Nyam!';

  @override
  String get ouchSound => 'Ai!';

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
  String get stickerBoughtStatus => 'Adhesiu nou! Enganxa\'l al teu àlbum.';

  @override
  String get albumButton => 'Àlbum d\'adhesius';

  @override
  String get albumTitle => 'L\'àlbum de Chigüi';

  @override
  String get albumHint => 'Arrossega cada adhesiu al seu lloc';

  @override
  String get albumEmpty =>
      'Encara no tens adhesius. Compra\'ls a la botiga amb les teves monedes!';

  @override
  String get albumStuck => 'Enganxat! Queda genial.';

  @override
  String get albumAllStuck => 'Tots enganxats! A la botiga n\'hi ha més.';

  @override
  String get albumComplete => 'Àlbum complet! Assoliment desbloquejat al 100%.';

  @override
  String get newStickersButton => 'Has vist els adhesius nous?';

  @override
  String get newStickerLabel => 'Nou!';

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
      'Toca els peus per passejar amb Chigüi, tan ràpid com vulguis!';

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
  String get remindersButton => 'Avisos';

  @override
  String get remindersOffInfo =>
      'Chigüi pot enviar un avís suau a l\'hora de menjar i quan necessiti anar al lavabo, mai en horari de classe ni de nit. Ara estan apagats.';

  @override
  String get remindersOnInfo =>
      'Els avisos estan encesos: uns quants al dia, a l\'hora de menjar i del lavabo. S\'aturen sols si passa un dia sense jugar.';

  @override
  String get remindersTurnOn => 'Encendre';

  @override
  String get remindersTurnOff => 'Apagar';

  @override
  String get remindersDenied =>
      'Les notificacions de Chigüi estan bloquejades a la configuració del mòbil.';

  @override
  String get remindersOpenSettings => 'Obre la configuració';

  @override
  String get reminderMeal =>
      'És l\'hora de menjar! A Chigüi li ve de gust alguna cosa bona.';

  @override
  String get reminderPotty =>
      'Chigüi necessita anar al lavabo! Li dones un cop de mà?';

  @override
  String get reminderChannel => 'La rutina de Chigüi';

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

  @override
  String get tapsCapped =>
      'Uf, uf! Chigüi s\'ha quedat sense alè de tant tocar. Demà més, o surt a caminar de debò.';

  @override
  String get piggyBankFull =>
      'La guardiola de Chigüi és plena per avui! Però jugar continua sent divertit.';

  @override
  String get schoolStatus => 'Ara mateix soc a classe! Ens veiem a la sortida.';
}
