import ceylon.whole {
	Whole,
	wholeOne=one
}

"Mediant of `a` and `b`.
 
 A _mediant_ of rationals _p_/_q_ and _p′_/_q′_ both in their lowest terms
 is a number (_p_ + _p′_)/(_q_ + _q′_)."
shared Rational mediant(Rational a, Rational b) {
	return Rational {
		numerator = a.numerator + b.numerator;
		denominator = a.denominator + b.denominator;
	};
}

"Returns a stream of _n_₁, _n_₂, … from some representation of
 `val` as a sum of form ±(_m_ + 1/_n_₁ + 1/_n_₂ + …)
 where ±_m_ is the integral part of `val`.
 In general, different representations are possible.
 
 If `val` is zero, returns an empty stream."
shared {Whole*} egyptianDenominators(Rational val) {
	{Whole*} denominators(Rational val) =>
			if (val.numerator.unit) then [val.denominator]
			else if (val.numerator.zero) then []
			else let (d = (val.inverse of Rational).wholePartWhole.plusInteger(1))
			{ d, *denominators(val - Rational.unreduced(wholeOne, d)) };
	return denominators(val.fractionalPart.magnitude);
}
