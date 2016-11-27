import ceylon.test {
	test,
	assertEquals,
	assertAll
}

import name.arseniiv.math.core {
	solveQuadratic
}

import test.name.arseniiv.math.core {
	...
}
import ceylon.numeric.float {
	random
}

shared class Tests() {
	Float aA = random() * 2k - 1k;
	Float rootA1 = random() * 2k - 1k;
	Float rootA2 = random() * 2k - 1k;
	Float aB = random() * 2G - 1G;
	Float rootB1 = random() * 2M - 1M;
	Float rootB2 = random() * 2m - 1m;
	Float aC = random() * 2k - 1k;
	Float rootC12 = random() * 2k - 1k;
	
	// a(x - x1)(x - x2) = a x^2 - a(x1 + x2)x + a x1 x2
	
	test
	shared void solveQuadraticTests() {
		assertAll([
			() => assertEquals(
				solveQuadratic(aA, -aA * (rootA1 + rootA2), aA * rootA1 * rootA2),
				sort([rootA1, rootA2]),
				"solveQuadratic two root random test #1",
				sequencesBy(floatNearlyEquals)),
			() => assertEquals(
				solveQuadratic(aB, -aB * (rootB1 + rootB2), aB * rootB1 * rootB2),
				sort([rootB1, rootB2]),
				"solveQuadratic two root random test #2",
				sequencesBy(floatNearlyEquals)),
			() => assertEquals(
				solveQuadratic(aC, -2.0 * aC * rootC12, aC * rootC12^2),
				[rootC12],
				"solveQuadratic single root random test",
				sequencesBy(floatNearlyEquals)),
			() => assertEquals(
				solveQuadratic(4.0, -4.0 * (-3.0 + 8.0), -4.0 * 3.0 * 8.0),
				sort([-3.0, 8.0]),
				"solveQuadratic two root test",
				sequencesBy(floatNearlyEquals)),
			() => assertEquals(
				solveQuadratic(1.0, -2.0 * 12.0, 12.0^2),
				[12.0],
				"solveQuadratic single root test",
				sequencesBy(floatNearlyEquals)),
			() => assertEquals(
				solveQuadratic(1.0, 2.0, 3.0),
				[],
				"solveQuadratic no root test",
				sequencesBy(floatNearlyEquals))
		]);
	}
}
