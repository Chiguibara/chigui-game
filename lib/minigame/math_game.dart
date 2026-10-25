import 'dart:math';

// Provisional tuning; adjust after playtests.

/// Questions per round, and answers to pick from.
const mathQuestions = 10;
const mathOptions = 3;

/// The levels to choose from, from first sums to secondary school (ESO);
/// harder levels pay more (`mathCoinsPerRound` in `rules.dart`).
enum MathLevel {
  /// Sums up to 10.
  sums,

  /// Sums and subtractions up to 20.
  upTo20,

  /// Sums and subtractions up to 100, with carrying.
  upTo100,

  /// The times tables, and dividing by them.
  tables,

  /// Two-digit times one-digit, and long division without remainder.
  multiplyDivide,

  /// Simple fractions and decimals.
  fractions,

  /// Negative numbers, powers, square roots, and the order of operations.
  integers,

  /// First-degree equations, percentages, and brackets.
  equations,
}

/// A number: whole, a fraction, or a decimal, kept as an exact fraction.
class Value {
  factory Value(int numerator, [int denominator = 1, bool decimal = false]) {
    assert(denominator != 0);
    final sign = denominator < 0 ? -1 : 1;
    final g = _gcd(numerator.abs(), denominator.abs());
    return Value._(
      sign * numerator ~/ g,
      sign * denominator ~/ g,
      decimal,
    );
  }

  /// A decimal number given in tenths, e.g. 25 is 2.5.
  factory Value.tenths(int tenths) => Value(tenths, 10, true);

  const Value._(this.numerator, this.denominator, this.decimal);

  final int numerator;
  final int denominator;

  /// Shown as a decimal (2.5) rather than a fraction (5/2).
  final bool decimal;

  bool get isWhole => denominator == 1;
  bool get isNegative => numerator < 0;

  @override
  bool operator ==(Object other) =>
      other is Value &&
      other.numerator == numerator &&
      other.denominator == denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  String toString() => format(this, decimalPoint: '.');
}

int _gcd(int a, int b) => b == 0 ? (a == 0 ? 1 : a) : _gcd(b, a % b);

/// [value] as players read it: "3", "−3", "3/4", or "2.5" (with the
/// language's [decimalPoint]).
String format(Value value, {required String decimalPoint}) {
  final sign = value.isNegative ? '−' : '';
  final n = value.numerator.abs();
  final d = value.denominator;
  if (value.isWhole) return '$sign$n';
  if (!value.decimal) return '$sign$n/$d';
  var places = 1;
  while (pow(10, places) % d != 0) {
    places++;
  }
  final scale = pow(10, places) ~/ d;
  final digits = (n * scale).toString().padLeft(places + 1, '0');
  final whole = digits.substring(0, digits.length - places);
  final fraction = digits
      .substring(digits.length - places)
      .replaceFirst(RegExp(r'0+$'), '');
  return '$sign$whole$decimalPoint$fraction';
}

enum Op { plus, minus, times, divide, equals, open, close, of }

/// A piece of a question, laid out left to right.
sealed class Term {
  const Term();
}

/// A number, in brackets when negative and not first, with an optional
/// power.
class Num extends Term {
  const Num(this.value, {this.power});

  final Value value;
  final int? power;
}

class Sym extends Term {
  const Sym(this.op);

  final Op op;
}

/// √n.
class Root extends Term {
  const Root(this.radicand);

  final int radicand;
}

/// n%.
class Percent extends Term {
  const Percent(this.percent);

  final int percent;
}

/// The unknown of an equation with its coefficient: "3x", "x", "−x".
class Unknown extends Term {
  const Unknown(this.coefficient);

  final int coefficient;
}

/// A question, its answer, and the answers to pick from in order.
class MathProblem {
  MathProblem(this.terms, this.answer, this.options)
    : assert(options.contains(answer));

  final List<Term> terms;
  final Value answer;
  final List<Value> options;

  /// An equation asks for x; anything else for its result.
  bool get asksForX => terms.any((t) => t is Unknown);

  /// Tells questions apart, to avoid repeats within a round.
  String get key => [
    for (final t in terms)
      switch (t) {
        Num(:final value, :final power) => '$value^$power',
        Sym(:final op) => op.name,
        Root(:final radicand) => 'r$radicand',
        Percent(:final percent) => '$percent%',
        Unknown(:final coefficient) => '${coefficient}x',
      },
  ].join(' ');
}

/// Makes up a new random question of [level]: nothing is stored, every
/// question is built from random numbers chosen so the answer comes out
/// clean (no negatives before [MathLevel.integers], exact divisions, perfect
/// squares under roots). The wrong answers are the usual slips (forgetting
/// to carry, the wrong operation, a sign) and near misses.
MathProblem makeProblem(MathLevel level, Random random) {
  int roll(int min, int max) => min + random.nextInt(max - min + 1);
  bool coin() => random.nextBool();
  int nonZero(int min, int max) {
    final n = roll(min, max - 1);
    return n >= 0 ? n + 1 : n;
  }

  const v = Value.new;
  Num n(int value) => Num(Value(value));
  const plus = Sym(Op.plus);
  const minus = Sym(Op.minus);
  const times = Sym(Op.times);
  const divide = Sym(Op.divide);

  final (List<Term> terms, Value answer, List<Value> slips) = switch (level) {
    MathLevel.sums => () {
      final a = roll(1, 8);
      final b = roll(1, 10 - a);
      return ([n(a), plus, n(b)], v(a + b), [v(a + b + 1), v(a + b - 1)]);
    }(),
    MathLevel.upTo20 =>
      coin()
          ? () {
              final a = roll(2, 18);
              final b = roll(1, 20 - a);
              return ([n(a), plus, n(b)], v(a + b), [v(a + b + 1), v(a)]);
            }()
          : () {
              final a = roll(3, 20);
              final b = roll(1, a - 1);
              return ([n(a), minus, n(b)], v(a - b), [v(a + b), v(a - b + 1)]);
            }(),
    MathLevel.upTo100 =>
      coin()
          ? () {
              final a = roll(11, 89);
              final b = roll(5, 100 - a);
              // Forgetting to carry the ten.
              final noCarry = (a ~/ 10 + b ~/ 10) * 10 + (a + b) % 10;
              return (
                [n(a), plus, n(b)],
                v(a + b),
                [v(noCarry), v(a + b + 10)],
              );
            }()
          : () {
              final a = roll(20, 99);
              final b = roll(5, a - 5);
              return (
                [n(a), minus, n(b)],
                v(a - b),
                [v(a - b + 10), v(a - b - 1)],
              );
            }(),
    MathLevel.tables => () {
      final a = roll(2, 10);
      final b = roll(1, 10);
      return coin()
          ? ([n(a), times, n(b)], v(a * b), [v(a * (b + 1)), v(a + b)])
          : ([n(a * b), divide, n(a)], v(b), [v(b + 1), v(a)]);
    }(),
    MathLevel.multiplyDivide =>
      coin()
          ? () {
              final a = roll(12, 99);
              final b = roll(3, 9);
              // Multiplying only the units.
              final unitsOnly = (a ~/ 10) * 10 + (a % 10) * b;
              return (
                [n(a), times, n(b)],
                v(a * b),
                [v(a * b + 10), v(a * b - 10), v(unitsOnly)],
              );
            }()
          : () {
              final b = roll(2, 9);
              final q = roll(12, 120);
              return ([n(q * b), divide, n(b)], v(q), [v(q + 10), v(q - 10)]);
            }(),
    MathLevel.fractions => switch (random.nextInt(4)) {
      // Fractions with the same denominator.
      0 => () {
        final d = roll(3, 10);
        final a = roll(1, d - 1);
        final b = roll(1, d - 1);
        return (
          [Num(v(a, d)), plus, Num(v(b, d))],
          v(a + b, d),
          // Adding the denominators too.
          [v(a + b, d + d), v(a + b + 1, d)],
        );
      }(),
      // A fraction of a number.
      1 => () {
        final d = roll(2, 5);
        final a = roll(1, d - 1);
        final k = roll(2, 10);
        return (
          [Num(v(a, d)), const Sym(Op.of), n(d * k)],
          v(a * k),
          [v(k), v(a * k + k)],
        );
      }(),
      // Adding decimals.
      2 => () {
        final a = roll(5, 99);
        final b = roll(5, 99);
        return (
          [Num(Value.tenths(a)), plus, Num(Value.tenths(b))],
          Value.tenths(a + b),
          // The decimal point in the wrong place.
          [Value.tenths(a + b + 10), Value.tenths((a + b) * 10)],
        );
      }(),
      // A decimal times 10 or 100.
      _ => () {
        final a = roll(11, 99);
        final by = coin() ? 10 : 100;
        return (
          [Num(Value.tenths(a)), times, n(by)],
          v(a * by, 10, true),
          [v(a * by, 100, true), v(a * by * 10, 10, true)],
        );
      }(),
    },
    MathLevel.integers => switch (random.nextInt(5)) {
      // Adding and subtracting with negatives.
      0 => () {
        final a = nonZero(-12, 12);
        final b = nonZero(-12, 12);
        return coin()
            ? ([n(a), plus, n(b)], v(a + b), [v(a - b), v(-a - b)])
            : ([n(a), minus, n(b)], v(a - b), [v(a + b), v(b - a)]);
      }(),
      // Multiplying with negatives: the sign rule.
      1 => () {
        final a = -roll(1, 10);
        final b = nonZero(-10, 10);
        return ([n(a), times, n(b)], v(a * b), [v(-a * b)]);
      }(),
      // Powers.
      2 => () {
        final power = roll(2, 3);
        final base = power == 2 ? roll(2, 12) : roll(2, 5);
        final result = pow(base, power).toInt();
        return (
          [Num(v(base), power: power)],
          v(result),
          [v(base * power), v(result + base)],
        );
      }(),
      // Square roots.
      3 => () {
        final k = roll(2, 15);
        return ([Root(k * k)], v(k), [v(k * k ~/ 2), v(k + 1)]);
      }(),
      // Multiplying comes first.
      _ => () {
        final a = roll(2, 20);
        final b = roll(2, 9);
        final c = roll(2, 9);
        return coin()
            ? ([n(a), plus, n(b), times, n(c)], v(a + b * c), [v((a + b) * c)])
            : (
                [n(a), minus, n(b), times, n(c)],
                v(a - b * c),
                [v((a - b) * c), v(b * c - a)],
              );
      }(),
    },
    MathLevel.equations => switch (random.nextInt(3)) {
      // ax ± b = c.
      0 => () {
        final a = nonZero(-9, 9);
        final x = nonZero(-10, 10);
        final b = nonZero(-20, 20);
        final c = a * x + b;
        return (
          [
            Unknown(a),
            b < 0 ? minus : plus,
            n(b.abs()),
            const Sym(Op.equals),
            n(c),
          ],
          v(x),
          // A sign slip, or forgetting to divide.
          [v(-x), v(c - b)],
        );
      }(),
      // A percentage of a number.
      1 => () {
        final percent = [5, 10, 20, 25, 50, 75][random.nextInt(6)];
        final whole = 100 ~/ _gcd(percent, 100) * roll(1, 12);
        final result = whole * percent ~/ 100;
        return (
          [Percent(percent), const Sym(Op.of), n(whole)],
          v(result),
          [v(whole - result), v(result * 10)],
        );
      }(),
      // Brackets first.
      _ => () {
        final a = nonZero(-9, 9);
        final b = roll(-9, 9);
        final c = nonZero(-9, 9);
        return (
          [
            n(a),
            times,
            const Sym(Op.open),
            n(b),
            minus,
            n(c),
            const Sym(Op.close),
          ],
          v(a * (b - c)),
          [v(a * b - c), v(a * (b + c))],
        );
      }(),
    },
  };

  return MathProblem(
    terms,
    answer,
    _options(
      answer,
      slips,
      allowNegative: level.index >= MathLevel.integers.index,
      random: random,
    ),
  );
}

/// The answer and [mathOptions] − 1 wrong ones in a random order: [slips]
/// first, then near misses.
List<Value> _options(
  Value answer,
  List<Value> slips, {
  required bool allowNegative,
  required Random random,
}) {
  Value off(int k) =>
      Value(answer.numerator + k, answer.denominator, answer.decimal);
  final near = [
    for (var k = 1; k <= 3; k++) ...[off(k), off(-k)],
  ];
  final wrong = <Value>[];
  for (final v in [...slips..shuffle(random), ...near]) {
    if (wrong.length == mathOptions - 1) break;
    if (v == answer || wrong.contains(v)) continue;
    if (v.isNegative && !allowNegative) continue;
    wrong.add(Value(v.numerator, v.denominator, answer.decimal));
  }
  return [answer, ...wrong]..shuffle(random);
}

enum Pick {
  right,
  wrong,

  /// Already tried, or the round is over.
  ignored,
}

/// A round of [mathQuestions] questions of one level. A wrong answer costs
/// nothing: it fades and the player tries again, but only answers right the
/// first time count.
class MathRound {
  MathRound(this.level, {Random? random}) : _random = random ?? Random() {
    _next();
  }

  final MathLevel level;
  final Random _random;
  final _asked = <String>{};

  late MathProblem problem;

  /// Wrong answers tried for this question.
  final tried = <Value>{};

  /// The question being answered, from 0.
  int question = 0;
  int rightFirstTime = 0;
  bool solved = false;

  bool get over => question == mathQuestions - 1 && solved;

  Pick pick(Value value) {
    if (solved || tried.contains(value)) return Pick.ignored;
    if (value != problem.answer) {
      tried.add(value);
      return Pick.wrong;
    }
    solved = true;
    if (tried.isEmpty) rightFirstTime++;
    return Pick.right;
  }

  /// Moves on to the next question once this one is solved.
  void next() {
    if (!solved || over) return;
    question++;
    _next();
  }

  void _next() {
    solved = false;
    tried.clear();
    // Small levels have few questions; repeats are fine once they run out.
    for (var i = 0; i < 20; i++) {
      problem = makeProblem(level, _random);
      if (_asked.add(problem.key)) return;
    }
  }
}
