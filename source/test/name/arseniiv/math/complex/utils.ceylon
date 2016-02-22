import ceylon.numeric.float {
	random
}

import name.arseniiv.math.complex {
	...
}

import test.name.arseniiv.math {
	...
}

"Comparison of [[Complex]]es componentwise by `f`."
Boolean complexesBy(Boolean(Float, Float) f)(Anything z, Anything w) {
	if (is Complex z, is Complex w) {
		value rectApplied =
				f(z.re, w.re) && f(z.im, w.im);
		if (rectApplied) { return true; }
		value distApplied =
				f((z - w).magnitude, 0.0) || f((z / w).magnitude, 1.0);
		return distApplied;
	}
	else { return false; }
}

"Default [[Complex]] near-equality comparison."
Boolean(Anything, Anything) complexNearlyEquals =
		complexesBy(nearlyEquals(2.0));

Complex randomComplex() {
	value z = Complex {
		random() - 0.5;
		random() - 0.5;
	};
	return random() * 10 ** z.normalized;
}