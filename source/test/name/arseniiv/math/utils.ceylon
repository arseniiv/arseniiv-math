import ceylon.numeric.float {
	random
}

import name.arseniiv.math {
	tau
}

import java.lang {
	JDouble=Double
}

shared Float epsilon = runtime.epsilon;

shared native Float minNormalFloat;

shared native("jvm") Float minNormalFloat = JDouble.\iMIN_NORMAL;

shared native("js") Float minNormalFloat = 2.22507385850720138e-308;

shared Float maxFloat = runtime.maxFloatValue;

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
	if (diffm == 0.0) { return true; }
	else if (a == 0.0 || b == 0.0 || diffm < minNormalFloat) {
		// a or b is zero or both are extremely close to it
		// relative error is less meaningful here
		return diffm < relativeError * minNormalFloat;
	} else { // use relative error
		return diffm  < relativeError * smallest((am + bm), maxFloat);
	}
}

"Comparison of [[Float]]s using given function."
shared Boolean floatsBy(Boolean(Float, Float) f)(Anything x, Anything y) {
	if (is Float x, is Float y) {
		return f(x, y);
	}
	else { return false; }
}

"Default [[Float]] near-equality comparison."
shared Boolean(Anything, Anything) floatNearlyEquals =
		floatsBy(nearlyEquals(1.0 * epsilon));

"Returns random angle (value in radians)."
shared Float randomAngle() => random() * tau;

"Returns random integer in range `0:valueCount`."
shared Integer randomInteger(Integer valueCount) =>
		(random() * valueCount).integer;
