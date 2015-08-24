import ceylon.math.float {
	random
}
import java.lang {
	JDouble = Double
}
import ceylon.test {
	equalsCompare
}
import info.arseniiv.math { tau }

"Machine epsilon for [[Float]]."
shared Float epsilon = 2.22e-16;

shared Float minNormalFloat = JDouble.\iMIN_NORMAL;

shared Float maxFloat = JDouble.\iMAX_VALUE;

"Returns true iff difference between `a` and `b` is more than given
 nonnegative relative calculation error."
shared Boolean nearlyEquals(Float relativeError = epsilon)
		(Float a, Float b) {
	// See http://floating-point-gui.de/errors/comparison/
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

"Comparison of [[Float]]s
 bootstrapping to [[equalsCompare]] for totality."
shared Boolean floatsBy(Boolean(Float, Float) f)(Anything x, Anything y) {
	if (is Float x, is Float y) {
		return f(x, y);
	}
	else { return equalsCompare(x, y); }
}

"Default [[Float]] near-equality comparison."
shared Boolean(Anything, Anything) floatNearlyEquals =
		floatsBy(nearlyEquals(1.0 * epsilon));

shared Float randomAngle() => random() * tau;

"Returns random integer in range `0:valueCount`."
shared Integer randomInteger(Integer valueCount) =>
		(random() * valueCount).integer;
