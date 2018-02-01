import name.arseniiv.math.core.internal {
	minNormalFloat
}

Float epsilon = runtime.epsilon;
Float maxFloat = runtime.maxFloatValue;

"Returns true iff difference between `a` and `b` is more than given
 nonnegative relative calculation error."
shared Boolean nearlyEquals(Float relativeErrorInEpsilons = 1.0)
(Float a, Float b) {
	// See http://floating-point-gui.de/errors/comparison/
	value relativeError = relativeErrorInEpsilons * epsilon;
	"Relative error value should be nonnegative."
	assert(!relativeError.negative);
	value am = a.magnitude;
	value bm = b.magnitude;
	value diffm = (a - b).magnitude;
	if (a == b) { return true; }
	else if (a == 0.0 || b == 0.0 || diffm < minNormalFloat) {
		// a or b is zero or both are extremely close to it
		// relative error is less meaningful here
		return diffm < relativeError * minNormalFloat;
	}
	else {
		// use relative error
		return diffm  < relativeError * smallest((am + bm), maxFloat);
	}
}
