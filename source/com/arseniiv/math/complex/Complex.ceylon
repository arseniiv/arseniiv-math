import ceylon.math.float {
	cos,
	sin,
	atan2,
	hypot
}
import com.arseniiv.math {
	signChar,
	tau
}

"A complex number."
by("arseniiv")
shared class Complex(re = 0.0, im = 0.0)
		extends Object()
		satisfies Exponentiable<Complex, Float>
		& Scalable<Float, Complex> {
	
	"Real part."
	shared Float re;
	
	"Imaginary part."
	shared Float im;
	
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
		if (other == 0) { return unit; }
		variable value n = other.magnitude;
		variable value x = other.positive then this else inverse;
		variable value y = unit;
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
		return "``re`` ``signChar(im)`` ``im.magnitude``i ";
	}
	
	shared actual Boolean equals(Object that) {
		if (is Complex that) {
			return re == that.re && im == that.im;
		}
		else { return false; }
	}
	
	hash => re.hash + im.hash;
	
	"Inverse `q^(-1)` of this complex number.
	 
	 Inverse satisfies followig identities:
	 - `z^(-1) * z == z * z^(-1) == 1`
	 - `z^(-1)^(-1) == z`
	 - `(z * w)^(-1) == z^(-1) * w^(-1)`"
	shared Complex inverse => 1.0/magnitudeSqr ** conjugate;
	
	"The magnitude (absolute value) of this complex number.
	 
	 Absolute value of `a + bi` is `sqrt(a^2 + b^2)`."
	shared Float magnitude => hypot(re, im);
	
	"The squared magnitude of this number."
	shared Float magnitudeSqr => re^2 + im^2;
	
	"This number scaled so its magnitude equals 1, or 0 if it is zero."
	shared Complex normalized {
		value m = magnitude;
		if (m == 0.0) { return zero; }
		else { return 1.0/m ** this; }
	}
	
	"Conjugate `q*` of this complex number.
	 
	 It has the same real part and negated imaginary part."
	shared Complex conjugate => Complex(re, -im);
	
	"Rotate this complex number counterclockwise by given `angle`."
	shared Complex rotate(Float angle) {
		return this * Complex(cos(angle), sin(angle));
	}
	
	"Returns the principal value of argument of this complex number
	 
	     z == magnitude ** exp(Complex(0, argument))
	     
	 principal value is contained in the interval `[-π; π]` "
	shared Float argument => atan2(im, re);
	
	Boolean finite => re.finite && im.finite;
	
	Boolean infinite => re.infinite || im.infinite;
}

"A zero [[Complex]]."
Complex zero = Complex();

"An unit [[Complex]]."
Complex unit = Complex(1.0);
