"Möbius transformation is an invertible transformation of
 a [[complex number|Complex]] `z` to
 
     (a z + b) / (c z + d)
 
 where all `a`, `b`, `c`, `d` are complex, and `a d != b c`,
 because in the latter case a transformation has no inverse."
shared class MobiusTransform(Complex a, Complex b, Complex c, Complex d)
		satisfies Summable<MobiusTransform>
		& Invertible<MobiusTransform> {
	"Transform should be invertible."
	assert(a * d != b * c);
	
	"Composition of Möbius transformations, satisfying
	 
	     (g + f).on(z) == g.on(f.on(z)) == compose(g.on, f.on)(z)
	 
	 Note this operation is _not_ commutative in general."
	shared actual MobiusTransform plus(MobiusTransform other) =>
			MobiusTransform {
				a = a * other.a + b * other.c;
				b = a * other.b + b * other.d;
				c = c * other.a + d * other.c;
				d = c * other.b + d * other.d;
			};
	
	"An inverse of this transformation."
	shared actual MobiusTransform negated =>
			MobiusTransform(d, -b, -c, a);
	
	"Action of this transformation on a given complex number `z`
	 which can also be [[Complex.infinity]]."
	shared Complex on(Complex z) =>
			z.finite then (a * z + b) / (c * z + d) else a / c;
	
	"Returns an inverse of determinant of a matrix [[a, b], [c, d]]."
	Complex overDet => (a * d - b * c).inverse;
	
	"Returns the same transformation as this, but with normalized
	 coefficients, so it can be more accurate in some cases."
	MobiusTransform normalized {
		value sd = root(overDet, 2);
		return MobiusTransform(a * sd, b * sd, c * sd, d * sd);
	}
	
	"(Half-)trace of a transformation.
	 Transformations having the same trace behave similarly."
	shared Complex trace => 0.5 ** (a + d) * overDet;
	
	"Pole is a pre-image of [[Complex.infinity]]."
	shared Complex pole => -d / c;
	
	"Inverse pole is an image of [[Complex.infinity]]."
	shared Complex inversePole => a / c;
	
	"Fixed points of a transformation.
	 
	 If a transformation is identity, any point is fixed,
	 and here we return `[]`.
	 Otherwise, two fixed points (or one double fixed point) exist."
	shared []|Complex[2] fixedPoints {
		value amd = a - d;
		if (c == Complex.zero) {
			return [-b / amd, Complex.infinity];
		}
		else {
			// naïve solution of a quadratic equation
			// `cz^2 - (a - d)z - b == 0`
			value dSqrt = root(amd^2.0 + 4.0 ** b * c, 2);
			return [0.5 ** (amd + dSqrt) / c, 0.5 ** (amd - dSqrt) / c];
		}
	}
	
}

"Make Möbius transformation specifying pre-images of `0`, `1` and `∞`."
shared MobiusTransform makeMobiusByPoints(Complex toZero, Complex toUnit,
		Complex toInfinity) {
	"Pre-images of a transform cannot coincide."
	assert(toZero != toUnit, toZero != toInfinity);
	if (toZero.infinite) {
		return MobiusTransform {
			a = Complex.zero;
			b = toInfinity - toUnit;
			c = -Complex.unit;
			d = toInfinity;
		};
	}
	if (toUnit.infinite) {
		return MobiusTransform {
			a = Complex.unit;
			b = -toZero;
			c = Complex.unit;
			d = -toInfinity;
		};		
	}
	if (toInfinity.infinite) {
		return MobiusTransform {
			a = -Complex.unit;
			b = toZero;
			c = Complex.zero;
			d = toZero - toUnit;
		};
	}
	// and, if all pre-images are finite, a general form is
	return MobiusTransform {
		a = toUnit - toInfinity;
		b = -toZero * (toUnit - toInfinity);
		c = toUnit - toZero;
		d = -toInfinity * (toUnit - toZero);
	};
}

