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
  String get tapHint => 'Toca a Chigüi para saludar';

  @override
  String get petAction => 'acariciar a Chigüi';

  @override
  String get lovedStatus => '¡Chigüi está feliz!';

  @override
  String get pettedLowStatus => '¡Eso le ha gustado! ¿Unos mimos más?';

  @override
  String get pettedMidStatus => '¡Qué gustito! ¿Un poquito más?';

  @override
  String get ateStatus => '¡Ñam! ¡Gracias!';

  @override
  String get fullStatus => 'Chigüi ya ha comido bastante por ahora';

  @override
  String get wantsFood => 'A Chigüi le apetece picar algo';

  @override
  String get wantsAffection => 'A Chigüi le apetecen unos mimos';

  @override
  String get wantsFun => 'Chigüi tiene ganas de jugar';

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
  String get bedButton => 'A dormir';

  @override
  String get vetButton => 'Al veterinario';

  @override
  String get cleanAction => 'limpiar';

  @override
  String get asleepStatus => 'Shhh… Chigüi está durmiendo';

  @override
  String get sickStatus => 'Chigüi no se encuentra bien. ¡Al veterinario!';

  @override
  String get pottyStatus => '¡Chigüi necesita ir al baño!';

  @override
  String get sleepyStatus => 'Chigüi tiene sueño';

  @override
  String get mealtimeStatus => '¡Es la hora de comer!';

  @override
  String get grumpyStatus =>
      'Anoche nadie acostó a Chigüi y está de morros. ¡Unos mimos y se le pasa!';

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
  String get minigameHint =>
      '¡Arrastra para mover a Chigüi y atrapar la fruta!';

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
  String coinsEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '+$count monedas',
      one: '+1 moneda',
      zero: '¡Chigüi se lo ha pasado bien igualmente!',
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
  String get chompSound => '¡Ñam!';

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
  String get shopTitle => 'La tienda de Chigüi';

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
  String get stickerBoughtStatus => '¡Pegatina añadida a tu álbum!';

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
  String get walkTitle => 'De paseo con Chigüi';

  @override
  String get walkIntro =>
      '¡Camina con el móvil en la mano o pulsa los pies uno detrás de otro!';

  @override
  String get walkIntroTapping =>
      '¡Pulsa los pies uno detrás de otro para pasear con Chigüi!';

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
  String get otherFoot => '¡El otro pie!';

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
  String get walksCapped =>
      '¡Cuánto paseo! A Chigüi se le han gastado las pilas. ¡Mañana más!';

  @override
  String get muteSounds => 'Silenciar sonidos';

  @override
  String get unmuteSounds => 'Activar sonidos';

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
}
