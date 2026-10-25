import '../game/pet_state.dart';
import '../l10n/app_localizations.dart';

extension PetName on AppLocalizations {
  /// The name the player gave Chigüi, or "Chigüi".
  String petName(PetState state) => state.name ?? chiguiName;
}
