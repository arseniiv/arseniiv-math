import ceylon.math.float {
	random
}
import ceylon.test {
	test,
	assertEquals
}

import info.arseniiv.math.quaternion {
	...
}

import test.info.arseniiv.math {
	...
}

shared class Tests() {
	value a = randomQuaternion();
	value b = randomQuaternion();
	value c = randomQuaternion();
	Float x = random() * 10;
	Float y = random() * 10;
	value ra = Quaternion.rotor(a.vec.normalized, randomAngle());
	value rb = Quaternion.rotor(b.vec.normalized, randomAngle());
	
	test
	shared void summableTests() {
		assertEquals((a + b) + c, a + (b + c),
				"`plus` associativity should hold",
				quaternionNearlyEquals);
		assertEquals(a + Quaternion.zero, a,
				"`Quaternion(0)` should be right neutral to `plus`");
		assertEquals(Quaternion.zero + a, a,
				"`Quaternion(0)` should be left neutral to `plus`");
	}
	
	test
	shared void invertibleTests() {
		value na = a.negated;
		assertEquals(a + na, Quaternion.zero, "`negated` should work as expected");
		assertEquals(b - a, b + na, "`minus` should work as expected");
	}
	
	test
	shared void numericTests() {
		value ia = a.inverse;
		assertEquals(a * Quaternion.unit, a,
				"`Quaternion(1)` should be left neutral to `times`");
		assertEquals(a * Quaternion.unit, a,
				"`Quaternion(1)` should be right neutral to `times`");
		assertEquals(a * ia, Quaternion.unit,
				"`inverse` should work as expected",
				quaternionNearlyEquals);
		assertEquals(a * (b + c), a * b + a * c,
				"`times` should be right-distributive over `plus`",
				quaternionNearlyEquals);
		assertEquals((a + b) * c, a * c + b * c,
				"`times` should be left-distributive over `plus`",
				quaternionNearlyEquals);
		assertEquals(b / a, b * ia,
				"`divided` should work as expected",
				quaternionNearlyEquals);
		// `times` commutativity `a * b == b * a` should not hold
	}
	
	test
	shared void scalableTests() {
		assertEquals(1.0 ** a, a, "scaling by unit should be identity");
		assertEquals((x * y) ** a, x ** (y ** a),
				"scaling should be compatible with multiplication",
				quaternionNearlyEquals);
		assertEquals((x + y) ** a, x ** a + y ** a,
				"scaling should be left-distributive",
				quaternionNearlyEquals);
		assertEquals(x ** (a + b), x ** a + x ** b,
				"scaling should be right-distributive",
				quaternionNearlyEquals);
		assertEquals((-1.0) ** a, -a,
				"scaling should be compatible with negation",
				quaternionNearlyEquals);
	}
	
	test
	shared void exponentiableTests() {
		assertEquals(a ^ 0.0, Quaternion.unit,
				"`power` with exponent of 0 should work as expected",
				quaternionNearlyEquals);
		assertEquals(a ^ 1.0, a,
				"`power` with exponent of 1 should work as expected",
				quaternionNearlyEquals);
		assertEquals(a ^ (-1.0), a.inverse,
				"`power` with exponent of -1 should work as expected",
				quaternionNearlyEquals);
		assertEquals(a ^ (x + y), a^x * a^y,
				"`power` with exponent sum should work as expected",
				quaternionNearlyEquals);
		assertEquals(a ^ (x - y), a^x / a^y,
				"`power` with exponent difference should work as expected",
				quaternionNearlyEquals);
		// these should not hold IIRC:
		// - multivaluedness of logarithm (as in case of complex numbers):
		//     a ^ (x * y) == (a^x)^y
		// - lack of product commutativity:
		//     (a * b)^x == a^x * b^x
	}
	
	test
	shared void conjugationTests() {
		value ac = a.conjugate;
		value bc = b.conjugate;
		assertEquals((a + b).conjugate, ac + bc,
				"conjugate of sum should be nice to us",
				quaternionNearlyEquals);
		assertEquals((a * b).conjugate, bc * ac,
				"conjugate of product should be nice to us",
				quaternionNearlyEquals);
		assertEquals(ac.conjugate, a,
				"conjugation should be an involution");
	}
	
	test
	shared void magnitudeTests() {
		value am = a.magnitude;
		value bm = b.magnitude;
		assertEquals((a * b).magnitude, am * bm,
			"magnitude of product should be nice to us",
			floatNearlyEquals);
		assertEquals(a.magnitudeSqr, am * am,
			"`magnitudeSqr` should indeed be what it claims to be",
			floatNearlyEquals);
		assertEquals(a.normalized.magnitude, 1.0,
			"magnitude of normalized quaternion should equal 1",
			floatNearlyEquals);
	}

	test
	shared void expLogTests() {
		assertEquals(exp(Quaternion.zero), Quaternion.unit, "`exp` of 0 should work as expected",
			quaternionNearlyEquals);
		assertEquals(exp(log(a)), a, "`exp` should be left inverse of `log`",
			quaternionNearlyEquals);
		// power series test for `exp`?
	}
	
	test
	shared void cosSinConsistencyTests() {
		value cs = cosSin(a);
		assertEquals(cs[0], cos(a), "`cos` and `cosSin` should work alike");
		assertEquals(cs[1], sin(a), "`sin` and `cosSin` should work alike");
	}
	
	test
	shared void coshSinhConsistencyTests() {
		value chsh = coshSinh(a);
		assertEquals(chsh[0], cosh(a), "`cosh` and `coshSinh` should work alike");
		assertEquals(chsh[1], sinh(a), "`sinh` and `coshSinh` should work alike");
	}
	
	test
	shared void rotorTests() {
		value c1 = c.rotate(ra);
		value c2 = ra * c * ra.conjugate;
		assertEquals(c1, c2, "`rotate` should work as expected",
				quaternionNearlyEquals);
		assertEquals(c.rotate(ra).rotate(rb), c.rotate(rb * ra),
				"rotations should compose as expected",
				quaternionNearlyEquals);
	}
	
	test
	shared void slerpTests() {
		value interpolator = slerp(ra, rb);
		assertEquals(interpolator(0.0), ra,
				"start point of interpolation should be reached at 0",
				quaternionNearlyEquals);
		assertEquals(interpolator(1.0), rb,
				"end point of interpolation should be reached at 1",
				quaternionNearlyEquals);
	}
}