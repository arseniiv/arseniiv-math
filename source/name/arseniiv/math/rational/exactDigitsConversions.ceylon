import ceylon.whole {
	wholeZero=zero,
	wholeOne=one,
	wholeNumber,
	Whole
}

import ceylon.collection {
	LinkedList,
	naturalOrderTreeSet
}

"Sequence of digits of form `±a.b(c) = ±a.bccc…` in some integer base ≥ 2.
 
 Shortest representation examples (base 10):
 * 0 is `Digits()`;
 * 123 is `Digits(false, [1, 2, 3])`;
 * −12 is `Digits(true, [1, 2])`;
 * −12.34 is `Digits(true, [1, 2], [3, 4])`;
 * 0.012 is `Digits(false, [], [0, 1, 2])`;
 * −1.23(4) is `Digits(true, [1], [2, 3], [4])`;
 * 0.(123) is `Digits(false, [], [], [1, 2, 3])`;
 * A.BCD₁₆ is `Digits(false, [10], [11, 12, 13], [0], 16)`;
 * 0.(001)₂ is `Digits(false, [], [], [0, 0, 1], 2)`;
 * −‹28›‹73›‹50›₁₀₀ is `Digits(true, [28, 73, 50], [], [], 100)`. "
shared class Digits extends Object {
	"Whether this sequence represents a negative number."
	shared Boolean negative;
	
	"Digits of the integer part of this sequence."
	shared [Integer*] integer;
	
	"Digits of the fractional part of this sequence except the periodic part."
	shared [Integer*] fractional;
	
	"Digits of the periodic fractional part of this sequence."
	shared [Integer+] periodicFractional;
	
	"The radix, ≥ 2."
	shared Integer radix;
	
	"[[Whole]] equivalent of [[radix]]."
	Whole wRadix;
	
	abstract new setRadix(Integer radix) extends Object() {
		assert (radix >= 2);
		this.radix = radix;
		wRadix = wholeNumber(radix);
	}
	
	shared new (
		"Defaults to [[false]]."
		Boolean negative = false,
		[Integer*] integer = [],
		[Integer*] fractional = [],
		[Integer+] periodicFractional = [0],
		Integer radix = 10
	) extends setRadix(radix) {
		assert (expand {
				integer,
				fractional,
				periodicFractional
			}.every((d) => 0 <= d < radix));
		
		this.negative = negative;
		this.integer = integer;
		this.fractional = fractional;
		this.periodicFractional = periodicFractional;
	}
	
	"Digits of a given rational number.
	 
	 Example: −23/74 = −0.3108108108… = −0.3(108), so
	     Digits.fromRational(Rational.small(-23, 74))
	 is
	     Digits {
	       negative = true;
	       integer = [];
	       fractional = [3];
	       periodicFractional = [1, 0, 8];
	       radix = 10;
	     }"
	see(`value rational`)
	shared new fromRational(Rational x, Integer radix = 10)
			extends setRadix(radix) {
		this.negative = x.negative;
		value xWhole = x.wholePart;
		this.integer = digitsFromWhole(xWhole.numerator, wRadix);
		value xFrac = x - xWhole;
		value [f, pf] = digitsFromProperFraction(xFrac, radix);
		this.fractional = f;
		this.periodicFractional = pf;
	}
	
	"Whole number by its digits with respect to [[radix]].
	 
	 If `radix = 10`, `wholeFromDigits([1, 2, 3]) == wholeNumber(123)`."
	Whole wholeFromDigits([Integer*] digits) {
		variable value result = wholeZero;
		for (d in digits) {
			result *= wRadix;
			result += wholeNumber(d);
		}
		return result;
	}
	
	"Rational number with these digits."
	see(`new fromRational`)
	// 12.123456(1234) == 12 + 123 456/1 000 000 + 1 234/9 999 000 000
	shared Rational? rational {
		value intVal = wholeFromDigits(integer);
		value fracVal = wholeFromDigits(fractional);
		value periodVal = wholeFromDigits(periodicFractional);
		value fracD = wRadix.powerOfInteger(fractional.size);
		value periodD = wRadix.powerOfInteger(periodicFractional.size) - wholeOne;
		value posNumerator = (intVal * fracD + fracVal) * periodD + periodVal;
		return Rational {
			numerator = if (negative) then -posNumerator else posNumerator;
			denominator = fracD * periodD;
		};
	}
	
	shared actual Boolean equals(Object that) =>
			if (is Digits that) then
				negative == that.negative &&
				integer == that.integer &&
				fractional == that.fractional &&
				periodicFractional == that.periodicFractional &&
				radix == that.radix
			else false;
	
	shared actual Integer hash {
		variable value hash = negative.hash;
		hash = 31 * hash + integer.hash;
		hash = 31 * hash + fractional.hash;
		hash = 31 * hash + periodicFractional.hash;
		hash = 31 * hash + radix;
		return hash;
	}
	
	string => String.sum {
		if (negative) then "-" else "+",
		" ".join(integer), ".",
		" ".join(fractional),
		"(", " ".join(periodicFractional), ")"
	};
}

[Integer*] digitsFromWhole(Whole w, Whole wRadix) {
	value digits = LinkedList<Integer>();
	variable value x = w.magnitude;
	while (!x.zero) {
		value [q, r] = x.quotientAndRemainder(wRadix);
		digits.insert(0, r.integer);
		x = q;
	}
	return digits.sequence();
}

[[Integer*], [Integer+]] digitsFromProperFraction(Rational a, Integer radix) {
	value digitsRemainders = LinkedList<[Integer, Whole]>();
	value remainders = naturalOrderTreeSet<Whole> {};
	value digits => digitsRemainders.collect(([d, r_]) => d);
	variable value x = a.numerator.magnitude;
	variable value y = a.denominator;
	while (!x.zero) {
		value [q, r] = x.timesInteger(radix).quotientAndRemainder(y);
		if (r in remainders) {
			assert (exists periodStartIndex =
					digitsRemainders.firstIndexWhere(([d, r_]) => r_ == r));
			value [frac, periodicFrac] = digits.slice(periodStartIndex);
			assert (nonempty periodicFrac);
			return [frac, periodicFrac];
		}
		digitsRemainders.add([q.integer, r]);
		remainders.add(r);
		x = r;
	}
	return [digits, [0]];
}

