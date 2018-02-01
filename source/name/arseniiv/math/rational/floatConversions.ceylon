import ceylon.whole {
	wholeZero=zero,
	Whole
}
import ceylon.numeric.float {
	floor
}

"Returns the [best rational approximation][1] of
 `number` within `radius`, that is, a simplest rational in
 a closed interval [`number` − `radius`; `number` + `radius`].
 
 [1]: [https://en.wikipedia.org/wiki/Continued_fraction#Best_rational_approximations]
 
 A rational _p_/_q_ is said to be _simpler_ than rational _p′_/_q′_
 if |_p_| ≤ |_p′_| and _q_ ≤ _q′_.
 
 Returns `null` if [[number]] is not [[finite|Float.finite]]."
see (`function approximate`)
shared Rational? approximateWithin(Float number, Float radius) =>
		let (absRadius = radius.magnitude)
		simplestRationalIn(number - absRadius, number + absRadius);

see (`function approximateWithin`)
Rational? simplestRationalIn(Float left, Float right) {
	value leftFrac = floatContinuedFraction(left);
	value rightFrac = floatContinuedFraction(right);
	// while left and right congruents both exist and are equal, take them,
	// and then, if both exist again, finish with a smaller of them plus 1
	value frac = zipPairs(leftFrac, rightFrac)
			.scan([true, true, wholeZero])(([prevEq, take, _], [l, r]) =>
		let (eq = l == r,
		     w = if (eq) then l else wholeMin(l, r).plusInteger(1))
		[eq, prevEq, w])
				.rest
				.takeWhile(([prevEq, take, w]) => take)
				.map(([prevEq, take, w]) => w);
	if (exists [n, d] = convergents(frac).last) {
		return Rational.unreduced(n, d); // gcd(n, d) == 1 for convergents
	}
	return null;
}

"Returns the [best rational approximation][1] of
 `number` with denominator not greater than `maxDenominator`.
 
 Returns `null` if [[number]] is not [[finite|Float.finite]].
 
 [1]: [https://en.wikipedia.org/wiki/Continued_fraction#Best_rational_approximations]"
see (`function approximateWithin`)
shared Rational? approximate(Float number, Whole maxDenominator) {
	value cs = convergents(floatContinuedFraction(number));
	if (exists [n, d] = cs.takeWhile(([n, d]) => d <= maxDenominator).last) {
		return Rational.unreduced(n, d); // gcd(n, d) == 1 for convergents
	}
	return null;
}

"Continued fraction representation of this value,
 or an empty stream if it’s not [[finite|Float.finite]]."
{Whole*} floatContinuedFraction(Float x) {
	if (!x.finite) { return []; }
	value int = floor(x);
	value fracInv = 1.0 / (x - int);
	return {
		floatWholePart(int) else wholeZero,
		*floatContinuedFraction(fracInv)
	};
}
