/// In-game achievements: kept in the save, never sent anywhere (no store
/// achievements, so the game stays offline and nothing leaves the device).
/// Once earned they stay; thresholds live in `rules.dart`.
enum Achievement {
  /// Bought every sticker in the shop.
  collector,

  /// A fruit catch round without a single stone, eating plenty of fruit.
  fruitMuncher,

  /// A bath without picking a wrong tool even once.
  cleanestInPond,

  /// Found Chigüi in every turn of hide and seek.
  capybaraEye,

  /// A memory board without turning a card already seen into a miss.
  capybaraMemory,

  /// A maths round all right the first time.
  mathWhiz,
}
