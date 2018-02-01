import ceylon.whole {
	wholeZero=zero,
	Whole,
	wholeOne=one
}

"A rational value of the given finite [continued fraction][1].
 [1]: [https://en.wikipedia.org/wiki/Continued_fraction]
 
 Doesn’t terminate if `cf` is infinite."
see(`function continuedFraction`)
shared Rational evalContinuedFraction({Whole+} cf) =>
		let ([n, d] = convergents(cf).last)
		Rational.unreduced(n, d); // gcd(n, d) == 1 for convergents

"A [continued fraction][1] representation of this value.
 [1]: [https://en.wikipedia.org/wiki/Continued_fraction]"
see(`function evalContinuedFraction`)
shared {Whole+} continuedFraction(Rational val) {
	value int = val.floor;
	value fracInv = (val - int).inverse;
	return {
		int.numerator,
		*continuedFraction(fracInv)
	};
}

"Convergents of a [continued fraction][1] `cf`.
 [1]: [https://en.wikipedia.org/wiki/Continued_fraction]"
Iterable<Whole[2], Absent> convergents<Absent>(Iterable<Whole, Absent> cf)
		given Absent satisfies Null =>
		object satisfies Iterable<Whole[2], Absent> {
	iterator() => object satisfies Iterator<Whole[2]> {
		value wIterator = cf.iterator();
		variable value n1 = wholeZero;
		variable value d1 = wholeOne;
		variable value n2 = wholeOne;
		variable value d2 = wholeZero;
		shared actual Whole[2]|Finished next() {
			switch (w = wIterator.next())
			case (finished) { return finished; }
			case (is Whole) {
				value n3 = w * n2 + n1;
				value d3 = w * d2 + d1;
				n1 = n2;
				d1 = d2;
				n2 = n3;
				d2 = d3;
				return [n3, d3];
			}
		}
	};
};
