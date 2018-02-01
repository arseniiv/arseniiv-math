import name.arseniiv.math.core {
	randomInteger
}

import name.arseniiv.math.rational {
	...
}

import test.name.arseniiv.math.core {
	...
}

Integer randomRationalDenomScale = 1k;
Integer randomRationalNumerScale = 10k;
Integer randomRationalNumerScale2 = randomRationalNumerScale * 2 + 1;
Rational randomRational() => Rational.small {
	randomInteger(randomRationalNumerScale2) - randomRationalNumerScale;
	randomInteger(randomRationalDenomScale) + 1;
};
