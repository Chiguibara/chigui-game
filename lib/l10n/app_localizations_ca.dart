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
  String tapHint(String name) {
    return 'Toca $name per saludar';
  }

  @override
  String petAction(String name) {
    return 'acariciar $name';
  }

  @override
  String lovedStatus(String name) {
    return 'Quina alegria té $name!';
  }

  @override
  String pettedLowStatus(String name) {
    return 'A $name li ha agradat! Unes quantes moixaines més?';
  }

  @override
  String get pettedMidStatus => 'Quin gustet! Una mica més?';

  @override
  String get ateStatus => 'Nyam! Gràcies!';

  @override
  String fullStatus(String name) {
    return '$name ja ha menjat prou de moment';
  }

  @override
  String wantsFood(String name) {
    return 'A $name li ve de gust fer un mos';
  }

  @override
  String wantsAffection(String name) {
    return 'A $name li vindrien de gust unes moixaines';
  }

  @override
  String wantsFun(String name) {
    return '$name té ganes de jugar';
  }

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
  String asleepStatus(String name) {
    return 'Xxxt… $name dorm';
  }

  @override
  String sickStatus(String name) {
    return '$name no es troba bé. Cap al veterinari!';
  }

  @override
  String pottyStatus(String name) {
    return '$name ha d\'anar al lavabo!';
  }

  @override
  String sleepyStatus(String name) {
    return '$name té son';
  }

  @override
  String get mealtimeStatus => 'És l\'hora de menjar!';

  @override
  String yawnStatus(String name) {
    return 'Uaaah… $name s\'ha despertat!';
  }

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
  String minigameHint(String name) {
    return 'Arrossega per moure $name: atrapa la fruita i esquiva les pedres!';
  }

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
  String coinsEarned(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count monedes',
      one: '+1 moneda',
      zero: '$name s\'ho ha passat bé igualment!',
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
  String hideHint(String name) {
    return '$name s\'amaga sota una caixa i després les caixes es mouen. No la perdis de vista!';
  }

  @override
  String hideWatch(String name) {
    return 'No perdis de vista la caixa de $name…';
  }

  @override
  String hidePick(String name) {
    return 'On és $name?';
  }

  @override
  String get hideFound => 'M\'has trobat!';

  @override
  String get hideMissed => 'Cucut! Era aquí!';

  @override
  String hideBox(int number) {
    return 'Caixa $number';
  }

  @override
  String timesFound(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has trobat $name $count vegades',
      one: 'Has trobat $name 1 vegada',
      zero: '$name s\'amaga de meravella!',
    );
    return '$_temp0';
  }

  @override
  String get bathTitle => 'Banyet';

  @override
  String bathHint(String name) {
    return '$name s\'ha empastifat jugant! Posa $name al cossi i tria les coses adequades per treure les taques enganxoses.';
  }

  @override
  String bathArrive(String name) {
    return 'Aquí arriba $name, amb quitrà fins a les orelles!';
  }

  @override
  String bathHopIn(String name) {
    return 'Toca $name i cap al cossi!';
  }

  @override
  String get bathWash => 'Tria alguna cosa i neteja les taques enganxoses';

  @override
  String get bathYuzu => 'Ni una taca! Tira uns quants yuzus a l\'aigua';

  @override
  String get bathSoak => 'Ahhh… un banyet de yuzu, quin gust';

  @override
  String bathDry(String name) {
    return 'Fora de l\'aigua! Eixuga $name amb la tovallola';
  }

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
  String shopTitle(String name) {
    return 'La botiga de $name';
  }

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
  String albumTitle(String name) {
    return 'L\'àlbum de $name';
  }

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
  String get updateButton => 'Versió nova! Actualitza';

  @override
  String get whatsNewLabel => 'Novetats';

  @override
  String get whatsNewOk => 'Genial!';

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
  String walkTitle(String name) {
    return 'De passeig amb $name';
  }

  @override
  String get walkIntro =>
      'Camina amb el mòbil a la mà o toca els peus l\'un darrere l\'altre!';

  @override
  String walkIntroTapping(String name) {
    return 'Toca els peus per passejar amb $name, tan ràpid com vulguis!';
  }

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
  String walksCapped(String name) {
    return 'Quants passejos! A $name se li han gastat les piles. Demà més!';
  }

  @override
  String get muteSounds => 'Silenciar els sons';

  @override
  String get unmuteSounds => 'Activar els sons';

  @override
  String get remindersButton => 'Avisos';

  @override
  String remindersOffInfo(String name) {
    return '$name pot enviar un avís suau a l\'hora de menjar i quan necessiti anar al lavabo, mai en horari de classe ni de nit. Ara estan apagats.';
  }

  @override
  String get remindersOnInfo =>
      'Els avisos estan encesos: uns quants al dia, a l\'hora de menjar i del lavabo. S\'aturen sols si passa un dia sense jugar.';

  @override
  String get remindersTurnOn => 'Encendre';

  @override
  String get remindersTurnOff => 'Apagar';

  @override
  String remindersDenied(String name) {
    return 'Les notificacions de $name estan bloquejades a la configuració del mòbil.';
  }

  @override
  String get remindersOpenSettings => 'Obre la configuració';

  @override
  String reminderMeal(String name) {
    return 'És l\'hora de menjar! A $name li ve de gust alguna cosa bona.';
  }

  @override
  String reminderPotty(String name) {
    return '$name necessita anar al lavabo! Li dones un cop de mà?';
  }

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
  String tapsCapped(String name) {
    return 'Uf, uf! $name s\'ha quedat sense alè de tant tocar. Demà més, o surt a caminar de debò.';
  }

  @override
  String piggyBankFull(String name) {
    return 'La guardiola de $name és plena per avui! Però jugar continua sent divertit.';
  }

  @override
  String get studyStatus => 'Pàgina rere pàgina! Amb tu estudio més de pressa.';

  @override
  String get mathTitle => 'Classe de mates';

  @override
  String mathHint(String name) {
    return '$name porta deures de mates! Tria un nivell i toca la resposta correcta. Sense pressa, i equivocar-se no passa res.';
  }

  @override
  String get mathLevelSums => 'Sumes fins a 10';

  @override
  String get mathLevelUpTo20 => 'Fins a 20';

  @override
  String get mathLevelUpTo100 => 'Fins a 100';

  @override
  String get mathLevelTables => 'Taules de multiplicar';

  @override
  String get mathLevelMultiplyDivide => 'Multiplicar i dividir';

  @override
  String get mathLevelFractions => 'Fraccions i decimals';

  @override
  String get mathLevelIntegers => 'Negatius i potències';

  @override
  String get mathLevelEquations => 'Equacions i %';

  @override
  String get mathTryAgain => 'Gairebé! Prova\'n una altra.';

  @override
  String mathRightFirstTime(int count, int total) {
    return '$count de $total a la primera!';
  }

  @override
  String get mathOf => 'de';

  @override
  String get mathTimes => '×';

  @override
  String get mathDivide => ':';

  @override
  String get mathDecimalPoint => ',';

  @override
  String mathPercent(int percent) {
    return '$percent %';
  }

  @override
  String get itemStickerPizza => 'Adhesiu de pizza';

  @override
  String get itemStickerBurger => 'Adhesiu d\'hamburguesa';

  @override
  String get itemStickerRamen => 'Adhesiu de ramen';

  @override
  String get itemStickerCroissant => 'Adhesiu de croissant';

  @override
  String get itemStickerCake => 'Adhesiu de pastís';

  @override
  String get itemStickerCookie => 'Adhesiu de galeta';

  @override
  String get itemStickerCocoa => 'Adhesiu de xocolata calenta';

  @override
  String get itemStickerMoon => 'Adhesiu de lluna';

  @override
  String get itemStickerSun => 'Adhesiu de sol';

  @override
  String get itemStickerEarth => 'Adhesiu de Terra';

  @override
  String get itemStickerSatellite => 'Adhesiu de satèl·lit';

  @override
  String get itemStickerGalaxy => 'Adhesiu de galàxia';

  @override
  String get itemStickerSparkles => 'Adhesiu d\'espurnes';

  @override
  String get itemStickerDpad => 'Adhesiu de creueta';

  @override
  String get itemStickerRobot => 'Adhesiu de robot';

  @override
  String get itemStickerPuzzle => 'Adhesiu de puzle';

  @override
  String get itemStickerDice => 'Adhesiu de dau';

  @override
  String get itemStickerChip => 'Adhesiu de xip';

  @override
  String get itemStickerKeyboard => 'Adhesiu de teclat';

  @override
  String get itemStickerTrophy => 'Adhesiu de trofeu';

  @override
  String get itemStickerLeaf => 'Adhesiu de fulla';

  @override
  String get itemStickerFlower => 'Adhesiu de flor';

  @override
  String get itemStickerLotus => 'Adhesiu de lotus';

  @override
  String get itemStickerDrop => 'Adhesiu de gota';

  @override
  String get itemStickerWaves => 'Adhesiu d\'onades';

  @override
  String get itemStickerForest => 'Adhesiu de bosc';

  @override
  String get itemStickerPaw => 'Adhesiu de petjada';

  @override
  String get itemStickerBee => 'Adhesiu d\'abella';

  @override
  String get itemStickerPiano => 'Adhesiu de piano';

  @override
  String get itemStickerHeadphones => 'Adhesiu d\'auriculars';

  @override
  String get itemStickerMic => 'Adhesiu de micròfon';

  @override
  String get itemStickerVinyl => 'Adhesiu de disc';

  @override
  String get itemStickerPalette => 'Adhesiu de paleta';

  @override
  String get itemStickerBrush => 'Adhesiu de pinzell';

  @override
  String get itemStickerMasks => 'Adhesiu de màscares';

  @override
  String get itemStickerBook => 'Adhesiu de llibre';

  @override
  String get itemStickerPencil => 'Adhesiu de llapis';

  @override
  String get itemStickerCalculator => 'Adhesiu de calculadora';

  @override
  String get itemStickerFlask => 'Adhesiu de ciència';

  @override
  String get itemStickerIdea => 'Adhesiu d\'idea';

  @override
  String get itemStickerBackpack => 'Adhesiu de motxilla';

  @override
  String get itemStickerGradCap => 'Adhesiu de birret';

  @override
  String get itemStickerRuler => 'Adhesiu d\'escaire';

  @override
  String get itemStickerRainbow => 'Adhesiu d\'arc de Sant Martí';

  @override
  String get itemStickerCloud => 'Adhesiu de núvol';

  @override
  String get itemStickerSmiley => 'Adhesiu de cara feliç';

  @override
  String get itemStickerGift => 'Adhesiu de regal';

  @override
  String get itemStickerParty => 'Adhesiu de confeti';

  @override
  String get itemStickerUmbrella => 'Adhesiu de paraigua';

  @override
  String get itemStickerDiamond => 'Adhesiu de diamant';

  @override
  String get albumPageFood => 'Berenars';

  @override
  String get albumPageSpace => 'Espai';

  @override
  String get albumPageGames => 'Videojocs';

  @override
  String get albumPageNature => 'Natura';

  @override
  String get albumPageMusic => 'Música i art';

  @override
  String get albumPageSchool => 'Escola';

  @override
  String get albumPageCute => 'Coses boniques';

  @override
  String get achievementsTitle => 'Assoliments';

  @override
  String get achievementUnlocked => 'Nou assoliment!';

  @override
  String get achievementWhere => 'El tens a l\'àlbum.';

  @override
  String get achievementOk => 'Visca!';

  @override
  String achievementsCount(int count, int total) {
    return '$count de $total';
  }

  @override
  String get achievementCollector => 'El col·leccionista';

  @override
  String get achievementCollectorHow =>
      'Compra tots els adhesius de la botiga.';

  @override
  String get achievementFruitMuncher => 'Menjafruites';

  @override
  String achievementFruitMuncherHow(int count) {
    return 'Atrapa $count fruites o més en una ronda sense que et toqui cap pedra.';
  }

  @override
  String get achievementCleanestInPond => 'El més net de la bassa';

  @override
  String achievementCleanestInPondHow(String name) {
    return 'Fes a $name un banyet sencer sense triar mai res equivocat.';
  }

  @override
  String get achievementCapybaraEye => 'Ull de capibara';

  @override
  String achievementCapybaraEyeHow(String name) {
    return 'Troba $name a tots els torns de fet i amagar.';
  }

  @override
  String get achievementCapybaraMemory => 'Memòria de capibara';

  @override
  String get achievementCapybaraMemoryHow =>
      'Acaba un memory sense fallar una parella que ja havies vist.';

  @override
  String get achievementMathWhiz => 'Cervellet';

  @override
  String get achievementMathWhizHow =>
      'Encerta les deu a la primera a la classe de mates.';

  @override
  String get albumPreviousPage => 'Pàgina anterior';

  @override
  String get albumNextPage => 'Pàgina següent';

  @override
  String get albumOtherPages => 'Hi ha més adhesius solts en altres pàgines.';

  @override
  String get renameButton => 'Canviar el nom';

  @override
  String renameTitle(String name) {
    return 'Quin nom li posem a $name?';
  }

  @override
  String get renameField => 'Nom';

  @override
  String get renameFirstFree =>
      'Aquest primer nom és de franc; després el podràs canviar un cop al mes.';

  @override
  String get renameMonthly => 'Pots canviar el nom un cop al mes.';

  @override
  String get renameWait => 'Podràs triar un altre nom el mes que ve.';

  @override
  String get renameSave => 'Desa';

  @override
  String get renameCancel => 'Cancel·la';

  @override
  String renamedStatus(String name) {
    return 'Mmm… $name. Crec que podria acostumar-me a aquest nom nou.';
  }

  @override
  String get itemOrange => 'Taronja';

  @override
  String get itemSeagull => 'Gavina';

  @override
  String get itemCrocodile => 'Cocodril';

  @override
  String get schoolStatus =>
      'Hora de classe! Estudio de valent, però una partideta també em ve de gust.';
}
