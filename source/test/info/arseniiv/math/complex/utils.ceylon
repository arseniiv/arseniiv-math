import ceylon.test {
	equalsCompare
}

import com.vasileff.ceylon.xmath.float {
	random
}

import info.arseniiv.math.complex {
	...
}

import test.info.arseniiv.math {
	...
}

"Comparison of [[Complex]]es componentwise by `f`
 bootstrapping to [[equalsCompare]] for totality."
Boolean complexesBy(Boolean(Float, Float) f)(Anything z, Anything w) {
	if (is Complex z, is Complex w) {
		value rectApplied =
				f(z.re, w.re) && f(z.im, w.im);
		if (rectApplied) { return true; }
		value distApplied =
				f((z - w).magnitude, 0.0) || f((z / w).magnitude, 1.0);
		return distApplied;
	}
	else { return equalsCompare(z, w); }
}

"Default [[Complex]] near-equality comparison."
Boolean(Anything, Anything) complexNearlyEquals =
		complexesBy(nearlyEquals(2.0 * epsilon));

Complex randomComplex() {
	value z = Complex {
		random() - 0.5;
		random() - 0.5;
	};
	return random() * 10 ** z.normalized;
}