import ceylon.math.float { random }
import ceylon.test {
	test,
	assertEquals
}
import info.arseniiv.math.complex { ... }
import test.info.arseniiv.math { ... }

shared class Tests() {
	value zero = Complex();
	value unit = Complex(1.0);
	value a = randomComplex();
	value b = randomComplex();
	value c = randomComplex();
	Float x = random() * 10;
	Float y = random() * 10;
	
	test
	shared void summableTests() {
		assertEquals((a + b) + c, a + (b + c),
			"`plus` associativity should hold",
			complexNearlyEquals);
		assertEquals(a + zero, a,
			"`Complex(0)` should be right neutral to `plus`");
		assertEquals(zero + a, a,
			"`Complex(0)` should be left neutral to `plus`");
	}
	
	test
	shared void invertibleTests() {
		value na = a.negated;
		assertEquals(a + na, zero, "`negated` should work as expected");
		assertEquals(b - a, b + na, "`minus` should work as expected");
	}
	
	test
	shared void numericTests() {
		value ia = a.inverse;
		assertEquals(a * unit, a,
			"`Complex(1)` should be left neutral to `times`");
		assertEquals(a * unit, a,
			"`Complex(1)` should be right neutral to `times`");
		assertEquals(a * ia, unit,
			"`inverse` should work as expected",
			complexNearlyEquals);
		assertEquals(a * (b + c), a * b + a * c,
			"`times` should be right-distributive over `plus`",
			complexNearlyEquals);
		assertEquals((a + b) * c, a * c + b * c,
			"`times` should be left-distributive over `plus`",
			complexNearlyEquals);
		assertEquals(b / a, b * ia,
			"`divided` should work as expected",
			complexNearlyEquals);
		assertEquals(a * b, b * a,
			"`times` should be commutative",
			complexNearlyEquals);
	}
	
	test
	shared void scalableTests() {
		assertEquals(1.0 ** a, a, "scaling by unit should be identity");
		assertEquals((x * y) ** a, x ** (y ** a),
			"scaling should be compatible with multiplication",
			complexNearlyEquals);
		assertEquals((x + y) ** a, x ** a + y ** a,
			"scaling should be left-distributive",
			complexNearlyEquals);
		assertEquals(x ** (a + b), x ** a + x ** b,
			"scaling should be right-distributive",
			complexNearlyEquals);
		assertEquals((-1.0) ** a, -a,
			"scaling should be compatible with negation",
			complexNearlyEquals);
	}
	
	test
	shared void exponentiableTests() {
		assertEquals(a ^ 0.0, unit,
			"`power` with exponent of 0 should work as expected",
			complexNearlyEquals);
		assertEquals(a ^ 1.0, a,
			"`power` with exponent of 1 should work as expected",
			complexNearlyEquals);
		assertEquals(a ^ (-1.0), a.inverse,
			"`power` with exponent of -1 should work as expected",
			complexNearlyEquals);
		assertEquals(a ^ (x + y), a^x * a^y,
			"`power` with exponent sum should work as expected",
			complexNearlyEquals);
		assertEquals(a ^ (x - y), a^x / a^y,
			"`power` with exponent difference should work as expected",
			complexNearlyEquals);
		// these should not hold IIRC:
		// - multivaluedness of logarithm:
		//     a ^ (x * y) == (a^x)^y
		//     (a * b) ^ x == a^x * b^x
	}
	
	test
	shared void conjugationTests() {
		value ac = a.conjugate;
		value bc = b.conjugate;
		assertEquals((a + b).conjugate, ac + bc,
			"conjugate of sum should be nice to us",
			complexNearlyEquals);
		assertEquals((a * b).conjugate, bc * ac,
			"conjugate of product should be nice to us",
			complexNearlyEquals);
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
		assertEquals(exp(zero), unit, "`exp` of 0 should work as expected",
			complexNearlyEquals);
		assertEquals(exp(log(a)), a, "`exp` should be left inverse of `log`",
			complexNearlyEquals);
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
	shared void rootTests() {
		value n = randomInteger(10) + 1;
		value roots = [ for (value i in 0:n) root(a, n, i) ];
		for (value z in roots.collect((w) => w^n.float)) {
			assertEquals(z, a, "`root` should work as expected",
				complexNearlyEquals);
		}
	}
}