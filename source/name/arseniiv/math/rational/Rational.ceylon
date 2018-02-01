import ceylon.whole {
	Whole,
	parseWhole,
	wholeOne=one,
	wholeGcd=gcd,
	wholeZero=zero,
	wholeTwo=two,
	wholeNumber
}

// TODO remove+rewrite when/if `ceylon.decimal` is cross-platform
Whole? floatWholePart(Float val) {
	value str = Float.format(val.wholePart, 0, 0).trimTrailing('.'.equals);
	return parseWhole(str);
}

Whole wholeMin(Whole x, Whole y) => if (x < y) then x else y;

"A rational number."
shared final class Rational
		extends Object
		satisfies Exponentiable<Rational, Integer>
		& Number<Rational> & Scalable<Integer, Rational> {
	
	"Numerator of a fraction in lowest terms representing this number. Thus,
	 
	     Rational.small(200, 300).numerator == 2"
	shared Whole numerator;
	
	"Denominator of a fraction in lowest terms representing this number. Thus,
	 
	     Rational.small(200, 300).denominator == 3"
	shared Whole denominator;
	
	see(`value nearestFloat`)
	variable Float? nearestFloatMemo = null;
	
	"Makes no checks for:
	 * zero/negative denominator,
	 * if `numerator`/`denominator` is in lowest terms.
	 
	 Use it only in case you know these holds."
	shared restricted(`module name.arseniiv.math.rational`)
	new unreduced(Whole numerator, Whole denominator) extends Object() {
		this.numerator = numerator;
		this.denominator = denominator;
	}
	
	"Create a [[Rational]] number equal to `numerator` / `denominator`.
	 
	 For shortcut version with [[Integer]] arguments, see [[small]]."
	throws (`class AssertionError`, "`denominator` is zero")
	shared new(numerator, denominator = wholeOne) extends Object() {
		variable Whole numerator;
		"Defaults to [[1|wholeOne]]."
		variable Whole denominator;
		
		"Denominator must be nonzero."
		assert (!denominator.zero);
		
		if (denominator.negative) {
			numerator = -numerator;
			denominator = -denominator;
		}
		value gcd = wholeGcd(numerator, denominator);
		this.numerator = numerator / gcd;
		this.denominator = denominator / gcd;
	}
	
	"Create a [[Rational]] number equal to `numerator` / `denominator`,
	 both [[Integer]].
	 
	 `Rational.small(d, n) == Rational(wholeNumber(d), wholeNumber(n))`."
	throws (`class AssertionError`, "`denominator` is zero")
	shared new small(numerator, denominator = 1)
			extends Rational(wholeNumber(numerator), wholeNumber(denominator)) {
		Integer numerator;
		"Defaults to 1."
		Integer denominator;
	}
	
	"Rational number `0`, an additive identity."
	shared new zero extends unreduced(wholeZero, wholeOne) {}
	
	"Rational number `1`, a multiplicative identity."
	shared new one extends unreduced(wholeOne, wholeOne) {}
	
	"Rational number `-1`."
	shared new minusOne extends unreduced(-wholeOne, wholeOne) {}
	
	"Rational number `2`."
	shared new two extends unreduced(wholeTwo, wholeOne) {}
	
	Float findNearestFloat() =>
			numerator.nearestFloat / denominator.nearestFloat;
	
	"The nearest [[Float]] to this number."
	shared Float nearestFloat =>
			nearestFloatMemo else (nearestFloatMemo = findNearestFloat());
	
	equals(Object that) =>
			if (is Rational that)
			then numerator == that.numerator && 
			     denominator == that.denominator
			else false;
	
	hash => numerator.hash + denominator.hash * 31;
	
	string => "``numerator`` / ``denominator``";
	
	shared actual Comparison compare(Rational other) {
		value left = numerator * other.denominator;
		value right = denominator * other.numerator;
		return left.compare(right);
	}
	
	plus(Rational other) => Rational {
		numerator = numerator * other.denominator + denominator * other.numerator;
		denominator = denominator * other.denominator;
	};
	
	minus(Rational other) => Rational {
		numerator = numerator * other.denominator - denominator * other.numerator;
		denominator = denominator * other.denominator;
	};
	
	negated => unreduced(-numerator, denominator);
	
	positive => numerator.positive;
	
	negative => numerator.negative;
	
	magnitude => unreduced(numerator.magnitude, denominator);
	
	sign => numerator.sign;
	
	times(Rational other) => Rational {
		numerator = numerator * other.numerator;
		denominator = denominator * other.denominator;
	};
	
	throws (`class AssertionError`, "`other` is zero")
	shared actual Rational divided(Rational other) {
		"Cannot divide by zero."
		assert (!numerator.zero);
		return Rational {
			numerator = numerator * other.denominator;
			denominator = denominator * other.numerator;
		};
	}
	
	"The multiplicative inverse of this value."
	throws (`class AssertionError`, "value is zero")
	shared Rational inverse {
		"Zero has no inverse."
		assert (!numerator.zero);
		return if (numerator.positive)
		then unreduced(denominator, numerator)
		else unreduced(-denominator, -numerator);
	}
	
	throws (`class AssertionError`, "`other` is negative and value is zero")
	shared actual Rational power(variable Integer other) {
		if (other.zero || numerator.unit) {
			return one;
		}
		variable value x = if (other.positive) then this else inverse;
		other = other.magnitude;
		if (other.unit) {
			return x;
		}
		variable value xn = x.numerator;
		variable value xd = x.denominator;
		variable value n = wholeOne;
		variable value d = wholeOne;
		while (!other.zero) {
			if (!other.even) {
				n *= xn;
				d *= xd;
				other -= 1;
			}
			xn *= xn;
			xd *= xd;
			other = other.rightArithmeticShift(1);
		}
		return unreduced(n, d);
	}
	
	scale(Integer scalar) => Rational {
		numerator = numerator.timesInteger(scalar);
		denominator = denominator;
	};
	
	plusInteger(Integer integer) => unreduced {
		numerator = numerator + denominator.timesInteger(integer);
		denominator = denominator;
	};
	
	timesInteger(Integer integer) => scale(integer);
	
	powerOfInteger(Integer integer) => power(integer);
	
	shared restricted(`module name.arseniiv.math.rational`)
	Whole wholePartWhole => numerator / denominator;
	
	see (`value floor`, `value ceiling`)
	shared actual Rational wholePart => unreduced(wholePartWhole, wholeOne);
	
	fractionalPart =>
			let (rem = numerator % denominator)
			if (rem.zero) then zero
			else unreduced(rem, denominator);
	
	"The largest value that is less than or equal to the
	 argument and equal to an integer."
	see (`value ceiling`, `value wholePart`)
	shared Rational floor =>
			if (denominator.unit) then this
			else if (numerator.positive) then wholePart
			else wholePart.plusInteger(-1);
	
	"The smallest value that is greater than or equal to the
	 argument and equal to an integer."
	see (`value floor`, `value wholePart`)
	shared Rational ceiling =>
			if (denominator.unit) then this
			else if (numerator.negative) then wholePart
			else wholePart.plusInteger(+1);
}
