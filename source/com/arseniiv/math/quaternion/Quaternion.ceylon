import ceylon.math.float {
	sqrt,
	cos,
	sin,
	atan2
}
import com.arseniiv.math {
	signChar
}

"A quaternion."
by("arseniiv")
shared class Quaternion(re = 0.0, x = 0.0, y = 0.0, z = 0.0)
		extends Object()
		satisfies Exponentiable<Quaternion, Float>
		& Scalable<Float, Quaternion> {
	
	"Real, or scalar part."
	shared Float re;
	
	"First component of a vector part."
	shared Float x;
	
	"Second component of a vector part."
	shared Float y;
	
	"Third component of a vector part."
	shared Float z;
	
	plus(Quaternion other) =>
			Quaternion(re + other.re, x + other.x, y + other.y, z + other.z);
	
	negated => Quaternion(-re, -x, -y, -z);
	
	minus(Quaternion other) =>
			Quaternion(re - other.re, x - other.x, y - other.y, z - other.z);
	
	"The product of this quaternion and the given one.
	 
	 Note that quaternion multiplication is not commutative in general
	 i. e. `q * r == r * q` may not hold.
	 It holds in following special cases (and some other cases too):
	 - `q` or `r` is a scalar (has zero vector part),
	 - `q == s * r` where `s` is scalar, or vice versa."
	shared actual Quaternion times(Quaternion other) {
		return Quaternion {
			re = re * other.re - x * other.x - y * other.y - z * other.z;
			x = re * other.x + x * other.re + y * other.z - z * other.y;
			y = re * other.y - x * other.z + y * other.re + z * other.x;
			z = re * other.z + x * other.y - y * other.x + z * other.re;
		};
	}
	
	"The quotient obtained by dividing this quaternion by the given one.
	 
	 It is a right division: only `(x / y) * y == x` and
	 `(x * y) / y == x` are guaranteed to hold if `y != 0`.
	 
	 `x / y` is defined as `x * y^(-1)`"
	see(`value inverse`)
	shared actual Quaternion divided(Quaternion other) =>
			(1.0/other.magnitudeSqr ** this) * other.conjugate;
	
	scale(Float scalar) =>
			Quaternion(scalar * re, scalar * x, scalar * y, scalar * z);
	
	see(`function integerPower`)
	shared actual Quaternion power(Float other) {
		value v = vector;
		value angle = other * atan2(v.magnitude, re);
		return magnitude^other **
				(Quaternion(cos(angle)) + sin(angle) ** v.normalized);
	}
	
	"The result of raising this number to the given _integer_ power."
	see(`function power`)
	shared Quaternion integerPower(Integer other) {
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
		return "``re`` ``signChar(x)`` ``x.magnitude``i " +
				"``signChar(y)`` ``y.magnitude``j " +
				"``signChar(z)`` ``z.magnitude``k";
	}
	
	shared actual Boolean equals(Object that) {
		if (is Quaternion that) {
			return re == that.re && x == that.x && y == that.y && z == that.z;
		}
		else { return false; }
	}
	
	hash => re.hash + x.hash + y.hash + z.hash;
	
	"Imaginary, or vector part."
	shared Quaternion vector => Quaternion(0.0, x, y, z);
	
	"Inverse `q^(-1)` of this quaternion.
	 
	 Inverse satisfies followig identities:
	 - `q^(-1) * q == q * q^(-1) == 1`
	 - `q^(-1)^(-1) == q`
	 - `(q * r)^(-1) == r^(-1) * q^(-1)`"
	shared Quaternion inverse => 1.0/magnitudeSqr ** conjugate;
	
	"The magnitude (absolute value) of this quaternion.
	 
	 Absolute value of `a + bi + cj + dk` is
	 `sqrt(a^2 + b^2 + c^2 + d^2)`."
	shared Float magnitude {
		// => sqrt(re^2 + x^2 + y^2 + z^2);
		// similarly to `hypot`, calculate
		// |a| * sqrt(1 + (b/a)^2 + (c/a)^2 + (d/a)^2)
		// where |a| >= |b|, a >= |c|, a >= |d|
		variable value a0 = [re, re.magnitude];
		variable value a1 = [x, x.magnitude];
		variable value a2 = [y, y.magnitude];
		variable value a3 = [z, z.magnitude];
		variable [Float, Float] t;
		if (a0[1] < a1[1]) { t = a1; a1 = a0; a0 = t; }
		if (a0[1] < a2[1]) { t = a2; a2 = a0; a0 = t; }
		if (a0[1] < a3[1]) { t = a3; a3 = a0; a0 = t; }
		value a = a0[0];
		if (a == 0.0) { return 0.0; }
		return a0[1] * sqrt(sum(sort(
			[1.0, (a1[0]/a)^2, (a2[0]/a)^2, (a3[0]/a)^2]).follow(0.0)));
	}
	
	"The squared magnitude of this quaternion."
	// shared Float magnitudeSqr => re^2 + x^2 + y^2 + z^2;
	shared Float magnitudeSqr => sum(sort([re^2, x^2, y^2, z^2]).follow(0.0));
	
	"Quaternion scaled so its magnitude equals 1, or 0 if it is zero."
	shared Quaternion normalized {
		value m = magnitude;
		if (m == 0.0) { return zero; }
		else { return 1.0/m ** this; }
	}
	
	"Conjugate `q*` of this quaternion.
	 
	 Conjugate quaternion has the same real part and negated vector part."
	shared Quaternion conjugate => Quaternion(re, -x, -y, -z);
	
	"Rotate this vector quaternion by given rotor quaternion.
	 
	 Returns the same as `rotor * this * rotor.conjugate`
	 with less computations."
	see(`function makeRotor`)
	shared Quaternion rotate(Quaternion rotor) {
		value rre = rotor.re;
		value rv = [rotor.x, rotor.y, rotor.z];
		return this + vectorMult2(rv, scalarVectorMult(rre, rv, [x, y, z]));
	}
	
	"Returns the argument of polar decomposition
	 
	     q == magnitude ** exp(argument ** vector.normalized)
	 
	 of this quaternion."
	shared Float argument => atan2(vector.magnitude, re);
}

"A zero [[Quaternion]]."
Quaternion zero = Quaternion();

"An unit [[Quaternion]]."
Quaternion unit = Quaternion(1.0);
