import 'dart:math';

import 'package:chigui_game/game/rules.dart';
import 'package:chigui_game/l10n/app_localizations_en.dart';
import 'package:chigui_game/l10n/app_localizations_es.dart';
import 'package:chigui_game/minigame/math_game.dart';
import 'package:chigui_game/minigame/math_screen.dart';
import 'package:flutter_test/flutter_test.dart';

double _number(Value v) => v.numerator / v.denominator;

/// Works a question out on its own, with the usual order of operations.
double _evaluate(List<Term> terms) {
  var i = 0;
  late double Function() sum;
  double atom() {
    final t = terms[i++];
    return switch (t) {
      Num(:final value, :final power) => pow(_number(value), power ?? 1) * 1.0,
      Root(:final radicand) => sqrt(radicand),
      Percent(:final percent) => percent / 100,
      Sym(op: Op.open) => () {
        final v = sum();
        i++; // The closing bracket.
        return v;
      }(),
      _ => throw StateError('Unexpected $t'),
    };
  }

  double product() {
    var v = atom();
    while (i < terms.length) {
      final t = terms[i];
      if (t is! Sym || ![Op.times, Op.divide, Op.of].contains(t.op)) break;
      i++;
      v = t.op == Op.divide ? v / atom() : v * atom();
    }
    return v;
  }

  sum = () {
    var v = product();
    while (i < terms.length) {
      final t = terms[i];
      if (t is! Sym || ![Op.plus, Op.minus].contains(t.op)) break;
      i++;
      v = t.op == Op.plus ? v + product() : v - product();
    }
    return v;
  };
  return sum();
}

void main() {
  test('every question has one right answer among distinct options', () {
    for (final level in MathLevel.values) {
      final random = Random(level.index);
      for (var k = 0; k < 2000; k++) {
        final p = makeProblem(level, random);
        expect(p.options, hasLength(mathOptions), reason: p.key);
        expect(p.options.toSet(), hasLength(mathOptions), reason: p.key);
        expect(p.options.where((o) => o == p.answer), hasLength(1));

        if (p.asksForX) {
          // a·x ± b = c, checked by putting x back.
          final a = (p.terms[0] as Unknown).coefficient;
          final sign = (p.terms[1] as Sym).op == Op.plus ? 1 : -1;
          final b = _number((p.terms[2] as Num).value);
          final c = _number((p.terms[4] as Num).value);
          expect(a * _number(p.answer) + sign * b, c, reason: p.key);
        } else {
          expect(_evaluate(p.terms), closeTo(_number(p.answer), 1e-9));
        }

        if (level.index < MathLevel.integers.index) {
          expect(p.options.every((o) => !o.isNegative), isTrue, reason: p.key);
        }
        if (level.index < MathLevel.fractions.index) {
          expect(p.options.every((o) => o.isWhole), isTrue, reason: p.key);
        }
      }
    }
  });

  test('first sums stay within 10', () {
    final random = Random(1);
    for (var k = 0; k < 500; k++) {
      final p = makeProblem(MathLevel.sums, random);
      expect(_number(p.answer), inInclusiveRange(2, 10));
    }
  });

  test('a round asks ten different questions and counts first tries', () {
    final round = MathRound(MathLevel.tables, random: Random(3));
    final asked = <String>{};
    for (var q = 0; q < mathQuestions; q++) {
      asked.add(round.problem.key);
      if (q.isEven) {
        final wrong = round.problem.options.firstWhere(
          (o) => o != round.problem.answer,
        );
        expect(round.pick(wrong), Pick.wrong);
        expect(round.pick(wrong), Pick.ignored);
      }
      expect(round.pick(round.problem.answer), Pick.right);
      expect(round.pick(round.problem.answer), Pick.ignored);
      round.next();
    }
    expect(round.over, isTrue);
    expect(asked, hasLength(mathQuestions));
    expect(round.rightFirstTime, mathQuestions ~/ 2);
  });

  test('harder levels pay more, and nothing right pays nothing', () {
    expect(mathCoinsPerRound, hasLength(MathLevel.values.length));
    for (var level = 1; level < mathCoinsPerRound.length; level++) {
      expect(
        mathCoinsPerRound[level],
        greaterThanOrEqualTo(mathCoinsPerRound[level - 1]),
      );
    }
    expect(mathCoinsPerRound.last, greaterThan(mathCoinsPerRound.first));
    final last = MathLevel.equations.index;
    expect(coinsForMath(last, 10, 10), mathCoinsPerRound.last);
    expect(coinsForMath(last, 5, 10), mathCoinsPerRound.last ~/ 2);
    expect(coinsForMath(last, 0, 10), 0);
    expect(coinsForMath(0, 5, 10), 1);
    expect(coinsForMath(0, 4, 10), 0);
  });

  test('numbers and questions are written as at school', () {
    expect(format(Value(-3), decimalPoint: ','), '−3');
    expect(format(Value(6, 8), decimalPoint: ','), '3/4');
    expect(format(Value.tenths(25), decimalPoint: ','), '2,5');
    expect(format(Value(125, 100, true), decimalPoint: '.'), '1.25');
    expect(format(Value.tenths(30), decimalPoint: ','), '3');

    final en = AppLocalizationsEn();
    final es = AppLocalizationsEs();
    MathProblem problem(List<Term> terms) =>
        MathProblem(terms, Value(0), [Value(0)]);
    expect(
      mathText(
        problem([Num(Value(12)), const Sym(Op.minus), Num(Value(-3))]),
        es,
      ),
      '12 − (−3)',
    );
    expect(
      mathText(
        problem([Num(Value(3, 4)), const Sym(Op.of), Num(Value(20))]),
        es,
      ),
      '3/4 de 20',
    );
    expect(
      mathText(
        problem([const Percent(25), const Sym(Op.of), Num(Value(80))]),
        es,
      ),
      '25\u00a0% de 80',
    );
    expect(
      mathText(
        problem([
          const Unknown(-1),
          const Sym(Op.minus),
          Num(Value(4)),
          const Sym(Op.equals),
          Num(Value(-7)),
        ]),
        en,
      ),
      '−x − 4 = −7',
    );
    expect(
      mathText(
        problem([
          Num(Value(-2)),
          const Sym(Op.times),
          const Sym(Op.open),
          Num(Value(5)),
          const Sym(Op.minus),
          Num(Value(-1)),
          const Sym(Op.close),
        ]),
        es,
      ),
      '−2 × (5 − (−1))',
    );
    expect(mathText(problem([Num(Value(12), power: 2)]), en), '12²');
  });
}
