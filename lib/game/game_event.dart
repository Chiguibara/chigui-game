/// Something worth remembering in Chigüi's history log.
enum EventType {
  mealOnTime,
  snack,
  mealMissed,
  pottyInToilet,
  accident,
  cleaned,
  gotSick,
  vetVisit,
  sentToBed,
  wentToBedAlone,
  played,
  walked,
  bought,
  packBought,
  packRemoved,
}

class GameEvent {
  const GameEvent(this.type, this.at);

  final EventType type;
  final DateTime at;

  @override
  bool operator ==(Object other) =>
      other is GameEvent && other.type == type && other.at.isAtSameMomentAs(at);

  @override
  int get hashCode => Object.hash(type, at.millisecondsSinceEpoch);

  @override
  String toString() => 'GameEvent(${type.name}, $at)';
}
