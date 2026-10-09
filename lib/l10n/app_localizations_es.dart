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
}
