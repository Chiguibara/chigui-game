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
}
