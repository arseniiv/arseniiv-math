import ceylon.test {
	test,
	assertEquals,
	assertTrue,
	assertAll
}

import ceylon.whole {
	wholeNumber
}

import ceylon.numeric.float {
	random
}

import name.arseniiv.math.core {
	randomInteger
}

import name.arseniiv.math.rational {
	...
}

import test.name.arseniiv.math.core {
	...
}

shared class Tests() {
	value a = randomRational();
	value b = randomRational();
	value c = randomRational();
	value x = randomInteger(101) - 50;
	value y = randomInteger(101) - 50;
	
	test
	shared void summableTests() {
		assertAll([
			() => assertEquals((a + b) + c, a + (b + c),
				"`plus` should be associative"),
			() => assertEquals(a + Rational.zero, a,
				"`Rational(0)` should be right neutral to `plus`"),
			() => assertEquals(Rational.zero + a, a,
				"`Rational(0)` should be left neutral to `plus`")
		]);
	}
	
	test
	shared void invertibleTests() {
		value na = a.negated;
		assertAll([
			() => assertEquals(a + na, Rational.zero,
				"`negated` should work as expected"),
			() => assertEquals(b - a, b + na,
				"`minus` should work as expected")
		]);
	}
	
	test
	shared void numericTests() {
		value ia = a.inverse;
		assertAll([
			() => assertEquals(a * Rational.one, a,
				"`Complex(1)` should be left neutral to `times`"),
			() => assertEquals(a * Rational.one, a,
				"`Complex(1)` should be right neutral to `times`"),
			() => assertEquals(a * ia, Rational.one,
				"`inverse` should work as expected"),
			() => assertEquals(a * (b + c), a * b + a * c,
				"`times` should be right-distributive over `plus`"),
			() => assertEquals((a + b) * c, a * c + b * c,
				"`times` should be left-distributive over `plus`"),
			() => assertEquals(b / a, b * ia,
				"`divided` should work as expected"),
			() => assertEquals(a + b, b + a,
				"`plus` should be commutative"),
			() => assertEquals((a * b) * c, a * (b * c),
				"`times` should be associative"),
			() => assertEquals(a * b, b * a,
				"`times` should be commutative")
		]);
	}
	
	test
	shared void scalableTests() {
		assertAll([
			() => assertEquals(1 ** a, a,
				"scaling by unit should be identity"),
			() => assertEquals((x * y) ** a, x ** (y ** a),
				"scaling should be compatible with multiplication"),
			() => assertEquals((x + y) ** a, x ** a + y ** a,
				"scaling should be left-distributive"),
			() => assertEquals(x ** (a + b), x ** a + x ** b,
				"scaling should be right-distributive"),
			() => assertEquals((-1) ** a, -a,
				"scaling should be compatible with negation")
		]);
	}
	
	test
	shared void exponentiableTests() {
		assertAll([
			() => assertEquals(a ^ 0, Rational.one,
				"`power` with exponent of 0 should work as expected"),
			() => assertEquals(a ^ 1, a,
				"`power` with exponent of 1 should work as expected"),
			() => assertEquals(a ^ (-1), a.inverse,
				"`power` with exponent of -1 should work as expected"),
			() => assertEquals(a ^ (x + y), a^x * a^y,
				"`power` with exponent sum should work as expected"),
			() => assertEquals(a ^ (x - y), a^x / a^y,
				"`power` with exponent difference should work as expected"),
			() => assertEquals(a ^ (x * y), (a^x)^y,
				"`power` with exponent product should work as expected"),
			() => assertEquals((a * b) ^ x, a^x * b^x,
				"`power` should be right-distributive over `times`")
		]);
	}
	
	test
	shared void magnitudeTests() {
		value am = a.magnitude;
		value bm = b.magnitude;
		assertAll([
			() => assertEquals(a.magnitude.timesInteger(a.sign), a,
				"`magnitude` and `sign` should be compatible"),
			() => assertEquals((a * b).magnitude, am * bm,
				"magnitude of product should be nice to us")
		]);
	}
	
	test
	shared void comparableTests() {
		assert (is Rational[3] sorted = sort { a, b, c }.sequence().tuple());
		value [a1, a2, a3] = sorted;
		assertAll([
			() => assertTrue((a <=> b == equal) == (a == b),
				"`compare` should be consistent with `equals`"),
			() => assertTrue(a <=> b == (b <=> a).reversed,
				"ordering should be symmetric"),
			() => assertTrue(!(a1 <= a2 <= a3) || a1 <= a3,
				"ordering should be transitive")
		]);
	}
	
	test
	shared void ceilingFloorTests() {
		value am = a.magnitude;
		assertAll([
			() => assertTrue(a.fractionalPart == Rational.zero ||
				a.floor.plusInteger(1) == a.ceiling,
				"`floor` and `ceiling` should be compatible"),
			() => assertEquals(am.floor, am.wholePart,
				"`floor` should be `wholePart` of positives"),
			() => assertEquals(am.negated.ceiling, am.negated.wholePart,
				"`ceiling` should be `wholePart` of negatives")
		]);
	}
	
	test
	shared void partTests() {
		assertEquals(a, a.wholePart + a.fractionalPart,
			"`wholePart` and `fractionalPart` should be compatible");
	}
	
	test
	shared void digitsTests() {
		assertAll([
			() => assertEquals(
				Digits.fromRational(Rational.small(97, 7)),
				Digits(false, [1, 3], [], [8, 5, 7, 1, 4, 2]),
				"97 / 7 ==> 13.(857142)"),
			() => assertEquals(
				Rational.small(-248781, 74),
				Digits(true, [3, 3, 6, 1], [9], [0, 5, 4]).rational,
				"-248781 / 74 <== -3361.9(054)"),
			() => assertEquals(
				Rational.small(3, 8),
				Digits(false, [], [0, 1, 1], [0], 2).rational,
				"3 / 8 <== 0.011_2")
		]);
	}
	
	test
	shared void approximationTests() {
		value r = random() * 100 - 50;
		value radius = random() + 1.0e-20;
		value d = wholeNumber(randomInteger(1000) + 1);
		value dinv = Rational(d).inverse;
		assert (exists rapproxr = approximateWithin(r, radius));
		assert (exists rapproxd = approximate(r, d));
		assertAll([
			() => assertTrue(r - radius <= rapproxr.nearestFloat <= r + radius,
				"`approximateWithin` should approximate"),
			() => assertTrue(
				(rapproxd - dinv).nearestFloat <= r <= (rapproxd + dinv).nearestFloat,
				"`approximate` should approximate"),
			() => assertTrue(rapproxd.denominator <= d,
				"`approximate` should approximate as specified")
		]);
	}
	
	test
	shared void egyptianTests() {
		assertEquals(
			a.fractionalPart.magnitude,
			sum { Rational.zero, for (d in egyptianDenominators(a)) Rational(d).inverse },
			"`egyptianDenominators` should be nice");
	}
	
	// and others!!!!
}
