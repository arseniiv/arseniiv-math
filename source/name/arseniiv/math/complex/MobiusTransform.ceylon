"[Möbius transformation](https://en.wikipedia.org/wiki/M%C3%B6bius_transformation)
 is an invertible transformation of a [[complex number|Complex]] `z` to
 
     (a z + b) / (c z + d)
 
 where all `a`, `b`, `c`, `d` are complex, and `a d != b c`,
 because in the latter case a transformation has no inverse."
shared class MobiusTransform
		satisfies Summable<MobiusTransform>
		& Invertible<MobiusTransform> {
	
	static variable MobiusTransform? identity_ = null;
	
	"Identity transformation, `MobiusTransform.identity(z) = z`."
	shared static MobiusTransform identity =>
			identity_ else (identity_ = MobiusTransform(
				Complex.one,	Complex.zero,
				Complex.zero, Complex.one));
	
	"A parameter of transformation."
	shared Complex a;
	
	"A parameter of transformation."
	shared Complex b;
	
	"A parameter of transformation."
	shared Complex c;
	
	"A parameter of transformation."
	shared Complex d;
	
	"Get Möbius transformation given its parameters.
	 
	 Parameters are defined up to multiplication by number—for example,
	 `MobiusTransform(a, b, c, d)` has the same effects as
	 `MobiusTransform(3*a, 3*b, 3*c, 3*d)`."
	shared new (Complex a, Complex b, Complex c, Complex d) {
		this.a = a;
		this.b = b;
		this.c = c;
		this.d = d;
	}
	
	"Make Möbius transformation specifying pre-images of `0`, `1` and `∞`."
	shared new byPreimages(Complex toZero, Complex toUnit,
		Complex toInfinity) {
		"Pre-images of a transform cannot coincide."
		assert(toZero != toUnit, toZero != toInfinity);
		if (toZero.infinite) {
			a = Complex.zero;
			b = toInfinity - toUnit;
			c = -Complex.one;
			d = toInfinity;
		}
		else if (toUnit.infinite) {
			a = Complex.one;
			b = -toZero;
			c = Complex.one;
			d = -toInfinity;
		}
		else if (toInfinity.infinite) {
			a = -Complex.one;
			b = toZero;
			c = Complex.zero;
			d = toZero - toUnit;
		}
		else {
			// and, if all pre-images are finite, a general form is
			a = toUnit - toInfinity;
			b = -toZero * (toUnit - toInfinity);
			c = toUnit - toZero;
			d = -toInfinity * (toUnit - toZero);
		}
	}
	
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
			if (z.finite) then (a * z + b) / (c * z + d) else a / c;
	
	"Returns an inverse of determinant of a matrix [[a, b], [c, d]]."
	Complex overDet => (a * d - b * c).inverse;
	
	// can’t decide if it’s needed. So it’s unshared now
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
		switch (res = solveQuadratic(c, a - d, b))
		case (is []|Complex[2]) { return res; }
		case ([Complex z]) { return [z, Complex.infinity]; }
	}
	
}

