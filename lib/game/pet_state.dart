/// The three needs. Each level goes from 0 to 1, where 1 means fully
/// satisfied.
enum Need { food, affection, fun }

class PetState {
  const PetState({required this.needs, required this.updatedAt});

  factory PetState.fresh(DateTime now) => PetState(
    needs: {for (final need in Need.values) need: initialLevel},
    updatedAt: now,
  );

  static const initialLevel = 0.8;

  final Map<Need, double> needs;

  /// When [needs] were last brought up to date.
  final DateTime updatedAt;

  double level(Need need) => needs[need] ?? initialLevel;

  PetState copyWith({Map<Need, double>? needs, DateTime? updatedAt}) =>
      PetState(
        needs: needs ?? this.needs,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
