import ceylon.numeric.float {
	random,
	sqrt
}

"Returns random angle (value in radians).
 
 It is picked uniformly in [0; 2π)."
shared Float randomAngle() => random() * tau;

"Returns random integer in range `0:valueCount`."
shared Integer randomInteger(Integer valueCount) =>
		(random() * valueCount).integer;

"Solve quadratic equation
 
     a x^2 + b x + c = 0
 
 the right way (I hope). You can safely pass `0` or near-zero values for `a`.
 
 If there are two roots, they are ordered."
shared []|Float[1]|Float[2] solveQuadratic(Float a, Float b, Float c) {
	value ba = -0.5 * b / a;
	value baSqr = ba^2;
	value ca = c / a;
	if (baSqr.finite && ca.finite) {
		value dSqr = baSqr - ca;
		if (dSqr.negative) { return []; }
		else {
			value d = let (d0 = sqrt(dSqr)) if (ba.positive) then d0 else -d0;
			value root1 = ba + d;
			value root2 = if (ca.magnitude > baSqr) then ba - d else ca / root1;
			// On `root2`: some people say `ca / root1` is not always the better.
			// I doubt it but lack the corresponding expertise to know for sure.
			if (nearlyEquals(1.0)(root1, root2)) {
				return [root1];
			}
			else {
				return if (ba.positive) then [root2, root1] else [root1, root2];
			}
		}
	}
	else {
		return [-c / b];
	}
}
