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
}
