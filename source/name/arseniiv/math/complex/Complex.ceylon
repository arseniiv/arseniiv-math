import ceylon.language {
	finfinity=infinity
}

import ceylon.numeric.float {
	cos,
	sin,
	atan2,
	hypot
}

import name.arseniiv.math.core.internal {
	signChar
}

"A complex number.
 
 You can get a _finite_ complex number with
 
     value z = Complex(0.0, 1.0); // imaginary uint
     
 and also a unique _infinite_ by using [[Complex.infinity]].
 It’s discouraged calling `Complex(re, im)` with `im` not being
 [[finite|Float.finite]] number. Invocations with not a finite `re`
 result in the following:
 - `Complex(infinity, …) == Complex(-infinity, …) == Complex.infinity`
 - `Complex(undefined, …)` are all considered undefined and
 not equal to anything other.
 
 Algebra on these values may fail. Guaranteed identities are:
 - `0.inverse == Complex.infinity`
 - `Complex.infinity.inverse == 0`"
shared final class Complex
		extends Object
		satisfies Exponentiable<Complex, Float> & Scalable<Float, Complex> {
	
	"Real part."
	shared Float re;
	
	"Imaginary part."
	shared Float im;
	
	"Returns complex number given its real and imaginary parts."
	shared new (Float re, Float im = 0.0)
			extends Object() {
		this.re = re;
		this.im = im;
	}
	
	"Returns complex number given its polar form:
	 [[magnitude|Complex.magnitude]] and [[argument|Complex.argument]].
	 
	 Note you can give any value of argument—not only principal one
	 that lies in `[-π; π]` range."
	shared new fromPolar(Float magnitude, Float argument)
			extends Complex(
					magnitude * cos(argument),
					magnitude * sin(argument)) {}
	
	"Returns unit complex number with given [[argument|Complex.argument]].
	 Its magnitude is 1.
	 
	 Note you can give any value of argument—not only principal one
	 that lies in `[-π; π]` range."
	shared new fromPolarUnit(Float argument)
			extends Complex(cos(argument), sin(argument)) {}
	
	"A zero complex number."
	shared new zero extends Complex(0.0) {}
	
	"A unit complex number."
	shared new one extends Complex(1.0) {}
	
	"An imaginary unit _i_."
	shared new i extends Complex(0.0, 1.0) {}
	
	"An infinite point ∞ of Riemann sphere. Sign is irrelevant."
	shared new infinity extends Complex(finfinity) {}
	
	plus(Complex other) =>
			Complex(re + other.re, im + other.im);
	
	negated => Complex(-re, -im);
	
	minus(Complex other) =>
			Complex(re - other.re, im - other.im);
	
	times(Complex other) => Complex {
		re = re * other.re - im * other.im;
		im = re * other.im + im * other.re;
	};
	
	see(`value inverse`)
	shared actual Complex divided(Complex other) =>
			(1.0/other.magnitudeSqr ** this) * other.conjugate;
	
	scale(Float scalar) =>
			Complex(scalar * re, scalar * im);
	
	see(`function integerPower`)
	shared actual Complex power(Float other) {
		value mag = magnitude^other;
		value arg = argument * other;
		return Complex(mag * cos(arg), mag * sin(arg));
	}
	
	"The result of raising this number to the given _integer_ power."
	see(`function power`)
	shared Complex integerPower(Integer other) {
		if (other == 0) { return one; }
		variable value n = other.magnitude;
		variable value x = other.positive then this else inverse;
		variable value y = one;
		while (n != 1) {
			if (!n.even) {
				y *= x;
				n--;
			}
			x *= x;
			n /= 2;
		}
		return x * y;
	}
	
	shared actual String string {
		//return finite
		//		then "``re`` ``signChar(im)`` ``im.magnitude``i"
		//		else "Complex.infinity";
		return "``re`` ``signChar(im)`` ``im.magnitude``i";
	}
	
	shared actual Boolean equals(Object that) {
		if (is Complex that) {
			if (re == that.re && im == that.im) { return true; }
			else if (re.infinite) { return that.re.infinite; }
		}
		return false;
	}
	
	hash => re.hash + (if (re.finite) then im.hash else 0);
	
	"Inverse `z^(-1)` of this complex number.
	 
	 Inverse satisfies followig identities:
	 - `z^(-1) * z == z * z^(-1) == 1`
	 - `z^(-1)^(-1) == z`
	 - `(z * w)^(-1) == z^(-1) * w^(-1)`"
	shared Complex inverse =>
			if (finite)
			then (if (re == 0.0 && im == 0.0)
						then infinity
						else 1.0/magnitudeSqr ** conjugate)
			else zero;
	
	"The magnitude (absolute value) of this complex number.
	 
	 Absolute value of `a + bi` is `sqrt(a^2 + b^2)`."
	aliased("abs", "norm")
	see(`value magnitudeSqr`)
	shared Float magnitude => hypot(re, im);
	
	"The squared [[magnitude]] of this number."
	shared Float magnitudeSqr => re^2 + im^2;
	
	"This number scaled so its [[magnitude]] equals 1, or 0 if it is zero."
	aliased("sign")
	shared Complex normalized {
		value m = magnitude;
		if (m == 0.0) { return zero; }
		else { return 1.0/m ** this; }
	}
	
	"Conjugate `q*` of this complex number.
	 
	 It has the same real part and negated imaginary part.
	 Or the same [[magnitude]] and negated [[argument]]."
	shared Complex conjugate => Complex(re, -im);
	
	"Rotate this complex number counterclockwise by given `angle`."
	shared Complex rotate(Float angle) {
		return this * Complex(cos(angle), sin(angle));
	}
	
	"Returns the principal value of argument of this complex number
	 
	     z == magnitude ** exp(Complex(0, argument))
	     
	 principal value is contained in the interval `[-π; π]`.
	 
	 Argument of `complexInfinity` is undefined,
	 argument of values close to zero may be equal to `0` or `±π`
	 according to cases listed on [[atan2]] behavior."
	aliased("angle")
	shared Float argument =>
			if (finite) then atan2(im, re) else +0.0/+0.0;
	
	"Determines whether this value is finite. Produces `false` for
	 [[Complex.infinity]] and undefined values."
	see(`value infinite`)
	see(`value undefined`)
	shared Boolean finite => re.finite;
	
	"Determines whether this value is [[Complex.infinity]]."
	see(`value finite`)
	see(`value undefined`)
	shared Boolean infinite => re.infinite;
	
	"Determines whether this value is undefined."
	see(`value finite`)
	see(`value infinite`)
	shared Boolean undefined => re.undefined;
}

