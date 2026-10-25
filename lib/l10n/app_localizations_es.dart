// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Chigüi';

  @override
  String get chiguiName => 'Chigüi';

  @override
  String tapHint(String name) {
    return 'Toca a $name para saludar';
  }

  @override
  String petAction(String name) {
    return 'acariciar a $name';
  }

  @override
  String lovedStatus(String name) {
    return '¡$name está feliz!';
  }

  @override
  String pettedLowStatus(String name) {
    return '¡A $name le ha gustado! ¿Unos mimos más?';
  }

  @override
  String get pettedMidStatus => '¡Qué gustito! ¿Un poquito más?';

  @override
  String get ateStatus => '¡Ñam! ¡Gracias!';

  @override
  String fullStatus(String name) {
    return '$name ya ha comido bastante por ahora';
  }

  @override
  String wantsFood(String name) {
    return 'A $name le apetece picar algo';
  }

  @override
  String wantsAffection(String name) {
    return 'A $name le apetecen unos mimos';
  }

  @override
  String wantsFun(String name) {
    return '$name tiene ganas de jugar';
  }

  @override
  String get feedButton => 'Dar de comer';

  @override
  String get needFood => 'Comida';

  @override
  String get needAffection => 'Cariño';

  @override
  String get needFun => 'Diversión';

  @override
  String needMeterLabel(String need, int percent) {
    return '$need: $percent %';
  }

  @override
  String get toiletButton => 'Al baño';

  @override
  String get vetButton => 'Al veterinario';

  @override
  String get cleanAction => 'limpiar';

  @override
  String asleepStatus(String name) {
    return 'Shhh… $name está durmiendo';
  }

  @override
  String sickStatus(String name) {
    return '$name no se encuentra bien. ¡Al veterinario!';
  }

  @override
  String pottyStatus(String name) {
    return '¡$name necesita ir al baño!';
  }

  @override
  String sleepyStatus(String name) {
    return '$name tiene sueño';
  }

  @override
  String get mealtimeStatus => '¡Es la hora de comer!';

  @override
  String yawnStatus(String name) {
    return 'Uaaah… ¡$name se ha despertado!';
  }

  @override
  String get messStatus => 'Algo huele raro… ¡toca limpiar!';

  @override
  String get reliefStatus => '¡Uf, qué alivio!';

  @override
  String get curedStatus => '¡Ya está! ¡Qué valiente!';

  @override
  String get cleanedStatus => '¡Todo limpio!';

  @override
  String get playButton => 'Jugar';

  @override
  String coinsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count monedas',
      one: '1 moneda',
    );
    return '$_temp0';
  }

  @override
  String get minigameTitle => 'Atrapa la fruta';

  @override
  String minigameHint(String name) {
    return 'Arrastra para mover a $name: ¡atrapa la fruta y esquiva las piedras!';
  }

  @override
  String get arrowKeysHint =>
      'En el ordenador también puedes usar las flechas.';

  @override
  String get startButton => '¡A jugar!';

  @override
  String secondsLeft(int seconds) {
    return '$seconds s';
  }

  @override
  String fruitsCaught(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count frutas atrapadas',
      one: '1 fruta atrapada',
      zero: 'Esta vez no hubo fruta',
    );
    return '$_temp0';
  }

  @override
  String coinsEarned(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count monedas',
      one: '+1 moneda',
      zero: '¡$name se lo ha pasado bien igualmente!',
    );
    return '$_temp0';
  }

  @override
  String get roundDone => '¡Buena partida!';

  @override
  String get playAgainButton => 'Otra vez';

  @override
  String get backHomeButton => 'Volver';

  @override
  String get otherGamesButton => 'Otros juegos';

  @override
  String get gamesTitle => '¿A qué jugamos?';

  @override
  String get memoryTitle => 'Memory de frutas';

  @override
  String get memoryHint =>
      '¡Da la vuelta a dos cartas cada vez y encuentra todas las parejas!';

  @override
  String cardsCount(int count) {
    return '$count cartas';
  }

  @override
  String get memoryCard => 'Carta';

  @override
  String pairsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count parejas encontradas',
      one: '1 pareja encontrada',
    );
    return '$_temp0';
  }

  @override
  String get hideTitle => 'Escondite';

  @override
  String hideHint(String name) {
    return '$name se esconde bajo una caja y luego las cajas se mueven. ¡No la pierdas de vista!';
  }

  @override
  String hideWatch(String name) {
    return 'No pierdas de vista la caja de $name…';
  }

  @override
  String hidePick(String name) {
    return '¿Dónde está $name?';
  }

  @override
  String get hideFound => '¡Me has encontrado!';

  @override
  String get hideMissed => '¡Cucú! ¡Estaba aquí!';

  @override
  String hideBox(int number) {
    return 'Caja $number';
  }

  @override
  String timesFound(int count, String name) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Has encontrado a $name $count veces',
      one: 'Has encontrado a $name 1 vez',
      zero: '¡$name se esconde de maravilla!',
    );
    return '$_temp0';
  }

  @override
  String get bathTitle => 'Bañito';

  @override
  String bathHint(String name) {
    return '¡$name se ha puesto perdido jugando! Mete a $name en el barreño y elige lo que haga falta para quitar las manchas pringosas.';
  }

  @override
  String bathArrive(String name) {
    return '¡Ahí viene $name, con pringue hasta las orejas!';
  }

  @override
  String bathHopIn(String name) {
    return '¡Toca a $name y al barreño!';
  }

  @override
  String get bathWash => 'Elige algo y limpia las manchas pringosas';

  @override
  String get bathYuzu => '¡Ni una mancha! Echa unos yuzus al agua';

  @override
  String get bathSoak => 'Ahhh… baño de yuzu, qué gustito';

  @override
  String bathDry(String name) {
    return '¡Fuera del agua! Seca a $name con la toalla';
  }

  @override
  String get bathDone => '¡Qué suavidad y qué brillo!';

  @override
  String bathSpots(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count manchas pringosas fuera',
      one: '1 mancha pringosa fuera',
    );
    return '$_temp0';
  }

  @override
  String get bathToolSoap => 'Jabón';

  @override
  String get bathToolBrush => 'Cepillo';

  @override
  String get bathToolLadle => 'Cazo de agua';

  @override
  String get bathToolYuzu => 'Yuzu';

  @override
  String get bathToolTowel => 'Toalla';

  @override
  String get chompSound => '¡Ñam!';

  @override
  String get ouchSound => '¡Auch!';

  @override
  String get walkedStatus => '¡Qué paseo más bonito!';

  @override
  String stepsLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pasos hoy',
      one: '1 paso hoy',
    );
    return '$_temp0';
  }

  @override
  String get shopButton => 'Tienda';

  @override
  String shopTitle(String name) {
    return 'La tienda de $name';
  }

  @override
  String get shopHint => '¿Qué nos llevamos hoy?';

  @override
  String get seasonalSection => 'De temporada';

  @override
  String get accessoriesSection => 'Accesorios';

  @override
  String get stickersSection => 'Pegatinas';

  @override
  String get wearButton => 'Ponérselo';

  @override
  String get takeOffButton => 'Quitárselo';

  @override
  String get inAlbum => 'En tu álbum';

  @override
  String get boughtStatus => '¡Nuevo look desbloqueado!';

  @override
  String get stickerBoughtStatus => '¡Pegatina nueva! Pégala en tu álbum.';

  @override
  String get albumButton => 'Álbum de pegatinas';

  @override
  String albumTitle(String name) {
    return 'El álbum de $name';
  }

  @override
  String get albumHint => 'Arrastra cada pegatina a su sitio';

  @override
  String get albumEmpty =>
      'Aún no tienes pegatinas. ¡Cómpralas en la tienda con tus monedas!';

  @override
  String get albumStuck => '¡Pegada! Queda genial.';

  @override
  String get albumAllStuck => '¡Todas pegadas! En la tienda hay más.';

  @override
  String get albumComplete => '¡Álbum completo! Logro desbloqueado al 100 %.';

  @override
  String get newStickersButton => '¿Has visto las pegatinas nuevas?';

  @override
  String get updateButton => '¡Versión nueva! Actualizar';

  @override
  String get whatsNewLabel => 'Novedades';

  @override
  String get whatsNewOk => '¡Guay!';

  @override
  String get newStickerLabel => '¡Nueva!';

  @override
  String notEnoughCoins(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Error 402: faltan $count monedas. ¡Unas partidas de Atrapa la fruta y arreglado!',
      one:
          'Error 402: falta 1 moneda. ¡Una partida de Atrapa la fruta y arreglado!',
    );
    return '$_temp0';
  }

  @override
  String get seasonSpooktober => 'Halloween';

  @override
  String get seasonChristmas => 'Navidad';

  @override
  String get seasonSpring => 'Primavera';

  @override
  String get seasonSummer => 'Verano';

  @override
  String get backSpooktober => 'Vuelve cada octubre';

  @override
  String get backChristmas => 'Vuelve cada Navidad';

  @override
  String get backSpring => 'Vuelve cada primavera';

  @override
  String get backSummer => 'Vuelve cada verano';

  @override
  String get tooEarlySpooktober =>
      'Los fantasmas siguen roncando en su cripta. ¡Vuelve en octubre!';

  @override
  String get tooEarlyChristmas =>
      'Los elfos de Papá Noel aún están compilando los regalos. ¡Vuelve en diciembre!';

  @override
  String get tooEarlySpring =>
      'Las flores siguen en fase beta. ¡Vuelve en primavera!';

  @override
  String get tooEarlySummer =>
      'La playa sigue cargando… 42 %. ¡Vuelve en verano!';

  @override
  String get itemGeekGlasses => 'Gafas de friki';

  @override
  String get itemBeanie => 'Gorrito de lana';

  @override
  String get itemScarf => 'Bufanda';

  @override
  String get itemHeadphones => 'Auriculares';

  @override
  String get itemGhost => 'Disfraz de fantasma';

  @override
  String get itemPumpkin => 'Calabaza';

  @override
  String get itemSantaHat => 'Gorro de Papá Noel';

  @override
  String get itemXmasTree => 'Árbol de Navidad';

  @override
  String get itemFlowerCrown => 'Corona de flores';

  @override
  String get itemButterfly => 'Mariposa amiga';

  @override
  String get itemSurfboard => 'Tabla de surf';

  @override
  String get itemSnorkel => 'Gafas de buceo con tubo';

  @override
  String get itemStickerStar => 'Pegatina de estrella';

  @override
  String get itemStickerHeart => 'Pegatina de corazón';

  @override
  String get itemStickerRocket => 'Pegatina de cohete';

  @override
  String get itemStickerGamepad => 'Pegatina de mando';

  @override
  String get itemStickerMusic => 'Pegatina de música';

  @override
  String get itemStickerIceCream => 'Pegatina de helado';

  @override
  String get walkButton => 'Pasear';

  @override
  String walkTitle(String name) {
    return 'De paseo con $name';
  }

  @override
  String get walkIntro =>
      '¡Camina con el móvil en la mano o pulsa los pies uno detrás de otro!';

  @override
  String walkIntroTapping(String name) {
    return '¡Pulsa los pies para pasear con $name, tan rápido como quieras!';
  }

  @override
  String get startWalkButton => '¡Vamos!';

  @override
  String get sensorWalkHint =>
      '¡Camina con el móvil en la mano o pulsa los pies!';

  @override
  String get pedometerWalkHint =>
      '¡Camina de verdad (aunque lleves el móvil en el bolsillo) o pulsa los pies!';

  @override
  String get tapFeetHint => 'Izquierdo, derecho, izquierdo, derecho…';

  @override
  String get leftFoot => 'pie izquierdo';

  @override
  String get rightFoot => 'pie derecho';

  @override
  String nextWalkProgress(int steps, int goal) {
    return '$steps de $goal pasos para el próximo paseo';
  }

  @override
  String walksToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count paseos hoy',
      one: '1 paseo hoy',
    );
    return '$_temp0';
  }

  @override
  String walksCapped(String name) {
    return '¡Cuánto paseo! A $name se le han gastado las pilas. ¡Mañana más!';
  }

  @override
  String get muteSounds => 'Silenciar sonidos';

  @override
  String get unmuteSounds => 'Activar sonidos';

  @override
  String get remindersButton => 'Avisos';

  @override
  String remindersOffInfo(String name) {
    return '$name puede mandar un aviso suave a la hora de comer y cuando necesite ir al baño, nunca en horario de clase ni de noche. Ahora están apagados.';
  }

  @override
  String get remindersOnInfo =>
      'Los avisos están encendidos: unos pocos al día, a la hora de comer y del baño. Se paran solos si pasa un día sin jugar.';

  @override
  String get remindersTurnOn => 'Encender';

  @override
  String get remindersTurnOff => 'Apagar';

  @override
  String remindersDenied(String name) {
    return 'Las notificaciones de $name están bloqueadas en los ajustes del móvil.';
  }

  @override
  String get remindersOpenSettings => 'Abrir ajustes';

  @override
  String reminderMeal(String name) {
    return '¡Es la hora de comer! A $name le apetece algo rico.';
  }

  @override
  String reminderPotty(String name) {
    return '¡$name necesita ir al baño! ¿Le echas una mano?';
  }

  @override
  String get reminderChannel => 'La rutina de Chigüi';

  @override
  String get packsSection => 'Packs';

  @override
  String get packGeekName => 'Pack friki';

  @override
  String get packSweetName => 'Pack dulce';

  @override
  String get packOwned => '¡Es tuyo!';

  @override
  String get packWaiting => 'Esperando a que un adulto lo apruebe…';

  @override
  String get buyPackTitle => 'Esto cuesta dinero de verdad';

  @override
  String get buyPackBody =>
      'Pregunta antes a un adulto. La tienda le pedirá que lo confirme y lo pague.';

  @override
  String get buyPackConfirm => 'Continuar al pago';

  @override
  String get buyPackCancel => 'Ahora no';

  @override
  String get packBoughtStatus => '¡Pack desbloqueado! Míralo en Accesorios.';

  @override
  String get packErrorStatus =>
      'La compra no se ha completado. Prueba más tarde.';

  @override
  String get itemPixelGlasses => 'Gafas pixeladas';

  @override
  String get itemWizardHat => 'Sombrero de mago';

  @override
  String get itemLaptop => 'Portátil con pegatinas';

  @override
  String get itemBunnyEars => 'Orejas de conejo';

  @override
  String get itemHeartGlasses => 'Gafas de corazón';

  @override
  String get itemCupcake => 'Magdalena';

  @override
  String get itemCap => 'Gorra';

  @override
  String get itemVikingHelmet => 'Casco vikingo';

  @override
  String get itemCrown => 'Corona';

  @override
  String get itemMustache => 'Bigote';

  @override
  String get itemGlasses3d => 'Gafas 3D';

  @override
  String get itemBandana => 'Pañuelo';

  @override
  String get itemMedal => 'Medalla';

  @override
  String get itemCape => 'Capa de superhéroe';

  @override
  String get itemBalloon => 'Globo de corazón';

  @override
  String get itemSkateboard => 'Monopatín';

  @override
  String get itemRetroConsole => 'Consola retro';

  @override
  String tapsCapped(String name) {
    return '¡Uf, uf! $name se ha quedado sin aliento de tanto pulsar. Mañana más, o sal a caminar de verdad.';
  }

  @override
  String piggyBankFull(String name) {
    return '¡La hucha de $name está llena por hoy! Pero jugar sigue siendo divertido.';
  }

  @override
  String get studyStatus => '¡Página tras página! Contigo estudio más rápido.';

  @override
  String get mathTitle => 'Clase de mates';

  @override
  String mathHint(String name) {
    return '¡$name trae deberes de mates! Elige un nivel y toca la respuesta correcta. Sin prisa, y equivocarse no pasa nada.';
  }

  @override
  String get mathLevelSums => 'Sumas hasta 10';

  @override
  String get mathLevelUpTo20 => 'Hasta 20';

  @override
  String get mathLevelUpTo100 => 'Hasta 100';

  @override
  String get mathLevelTables => 'Tablas de multiplicar';

  @override
  String get mathLevelMultiplyDivide => 'Multiplicar y dividir';

  @override
  String get mathLevelFractions => 'Fracciones y decimales';

  @override
  String get mathLevelIntegers => 'Negativos y potencias';

  @override
  String get mathLevelEquations => 'Ecuaciones y %';

  @override
  String get mathTryAgain => '¡Casi! Prueba otra.';

  @override
  String mathRightFirstTime(int count, int total) {
    return '¡$count de $total a la primera!';
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
  String get itemStickerPizza => 'Pegatina de pizza';

  @override
  String get itemStickerBurger => 'Pegatina de hamburguesa';

  @override
  String get itemStickerRamen => 'Pegatina de ramen';

  @override
  String get itemStickerCroissant => 'Pegatina de cruasán';

  @override
  String get itemStickerCake => 'Pegatina de tarta';

  @override
  String get itemStickerCookie => 'Pegatina de galleta';

  @override
  String get itemStickerCocoa => 'Pegatina de chocolate';

  @override
  String get itemStickerMoon => 'Pegatina de luna';

  @override
  String get itemStickerSun => 'Pegatina de sol';

  @override
  String get itemStickerEarth => 'Pegatina de Tierra';

  @override
  String get itemStickerSatellite => 'Pegatina de satélite';

  @override
  String get itemStickerGalaxy => 'Pegatina de galaxia';

  @override
  String get itemStickerSparkles => 'Pegatina de destellos';

  @override
  String get itemStickerDpad => 'Pegatina de cruceta';

  @override
  String get itemStickerRobot => 'Pegatina de robot';

  @override
  String get itemStickerPuzzle => 'Pegatina de pieza de puzle';

  @override
  String get itemStickerDice => 'Pegatina de dado';

  @override
  String get itemStickerChip => 'Pegatina de chip';

  @override
  String get itemStickerKeyboard => 'Pegatina de teclado';

  @override
  String get itemStickerTrophy => 'Pegatina de trofeo';

  @override
  String get itemStickerLeaf => 'Pegatina de hoja';

  @override
  String get itemStickerFlower => 'Pegatina de flor';

  @override
  String get itemStickerLotus => 'Pegatina de loto';

  @override
  String get itemStickerDrop => 'Pegatina de gota';

  @override
  String get itemStickerWaves => 'Pegatina de olas';

  @override
  String get itemStickerForest => 'Pegatina de bosque';

  @override
  String get itemStickerPaw => 'Pegatina de huella';

  @override
  String get itemStickerBee => 'Pegatina de abeja';

  @override
  String get itemStickerPiano => 'Pegatina de piano';

  @override
  String get itemStickerHeadphones => 'Pegatina de auriculares';

  @override
  String get itemStickerMic => 'Pegatina de micrófono';

  @override
  String get itemStickerVinyl => 'Pegatina de disco';

  @override
  String get itemStickerPalette => 'Pegatina de paleta';

  @override
  String get itemStickerBrush => 'Pegatina de pincel';

  @override
  String get itemStickerMasks => 'Pegatina de máscaras';

  @override
  String get itemStickerBook => 'Pegatina de libro';

  @override
  String get itemStickerPencil => 'Pegatina de lápiz';

  @override
  String get itemStickerCalculator => 'Pegatina de calculadora';

  @override
  String get itemStickerFlask => 'Pegatina de ciencia';

  @override
  String get itemStickerIdea => 'Pegatina de idea';

  @override
  String get itemStickerBackpack => 'Pegatina de mochila';

  @override
  String get itemStickerGradCap => 'Pegatina de birrete';

  @override
  String get itemStickerRuler => 'Pegatina de escuadra';

  @override
  String get itemStickerRainbow => 'Pegatina de arcoíris';

  @override
  String get itemStickerCloud => 'Pegatina de nube';

  @override
  String get itemStickerSmiley => 'Pegatina de carita feliz';

  @override
  String get itemStickerGift => 'Pegatina de regalo';

  @override
  String get itemStickerParty => 'Pegatina de confeti';

  @override
  String get itemStickerUmbrella => 'Pegatina de paraguas';

  @override
  String get itemStickerDiamond => 'Pegatina de diamante';

  @override
  String get albumPageFood => 'Meriendas';

  @override
  String get albumPageSpace => 'Espacio';

  @override
  String get albumPageGames => 'Videojuegos';

  @override
  String get albumPageNature => 'Naturaleza';

  @override
  String get albumPageMusic => 'Música y arte';

  @override
  String get albumPageSchool => 'Cole';

  @override
  String get albumPageCute => 'Cosas bonitas';

  @override
  String get achievementsTitle => 'Logros';

  @override
  String get achievementUnlocked => '¡Nuevo logro!';

  @override
  String get achievementWhere => 'Lo tienes en el álbum.';

  @override
  String get achievementOk => '¡Bien!';

  @override
  String achievementsCount(int count, int total) {
    return '$count de $total';
  }

  @override
  String get achievementCollector => 'El coleccionista';

  @override
  String get achievementCollectorHow =>
      'Compra todas las pegatinas de la tienda.';

  @override
  String get achievementFruitMuncher => 'Zampafrutas';

  @override
  String achievementFruitMuncherHow(int count) {
    return 'Atrapa $count frutas o más en una ronda sin que te dé ni una piedra.';
  }

  @override
  String get achievementCleanestInPond => 'El más limpio de la charca';

  @override
  String achievementCleanestInPondHow(String name) {
    return 'Dale a $name un bañito entero sin elegir nunca algo equivocado.';
  }

  @override
  String get achievementCapybaraEye => 'Ojo de capibara';

  @override
  String achievementCapybaraEyeHow(String name) {
    return 'Encuentra a $name en todos los turnos del escondite.';
  }

  @override
  String get achievementCapybaraMemory => 'Memoria de capibara';

  @override
  String get achievementCapybaraMemoryHow =>
      'Termina un memory sin fallar una pareja que ya habías visto.';

  @override
  String get achievementMathWhiz => 'Cerebrito';

  @override
  String get achievementMathWhizHow =>
      'Acierta las diez a la primera en la clase de mates.';

  @override
  String get albumPreviousPage => 'Página anterior';

  @override
  String get albumNextPage => 'Página siguiente';

  @override
  String get albumOtherPages => 'Hay más pegatinas sueltas en otras páginas.';

  @override
  String get renameButton => 'Cambiar el nombre';

  @override
  String renameTitle(String name) {
    return '¿Cómo llamamos a $name?';
  }

  @override
  String get renameField => 'Nombre';

  @override
  String get renameFirstFree =>
      'Este primer nombre es gratis; después podrás cambiarlo una vez al mes.';

  @override
  String get renameMonthly => 'Puedes cambiar el nombre una vez al mes.';

  @override
  String get renameWait => 'Podrás elegir otro nombre el mes que viene.';

  @override
  String get renameSave => 'Guardar';

  @override
  String get renameCancel => 'Cancelar';

  @override
  String renamedStatus(String name) {
    return 'Mmm… $name. Creo que podría acostumbrarme a este nuevo nombre.';
  }

  @override
  String get itemOrange => 'Naranja';

  @override
  String get itemSeagull => 'Gaviota';

  @override
  String get itemCrocodile => 'Cocodrilo';

  @override
  String get schoolStatus =>
      '¡Hora de clase! Estoy estudiando mucho, pero un jueguecito también me apetece.';
}
