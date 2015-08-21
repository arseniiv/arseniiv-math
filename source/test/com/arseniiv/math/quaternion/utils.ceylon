import ceylon.math.float {
	random
}
import ceylon.test {
	equalsCompare
}
import test.com.arseniiv.math { ... }
import com.arseniiv.math.quaternion { ... }

"Comparison of [[Quaternion]]s componentwise by `f`
 bootstrapping to [[equalsCompare]] for totality."
Boolean quaternionsBy(Boolean(Float, Float) f)(Anything q, Anything r) {
	if (is Quaternion q, is Quaternion r) {
		value rectApplied =
				f(q.re, r.re) && f(q.x, r.x) && f(q.y, r.y) && f(q.z, r.z);
		if (rectApplied) { return true; }
		value distApplied =
				f((q - r).magnitude, 0.0) || f((q / r).magnitude, 1.0);
		return distApplied;
	}
	else { return equalsCompare(q, r); }
}

"Default [[Quaternion]] near-equality comparison."
Boolean(Anything, Anything) quaternionNearlyEquals =
		quaternionsBy(nearlyEquals(2.0 * epsilon));

Quaternion randomQuaternion() {
	value q = Quaternion {
		random() - 0.5;
		random() - 0.5;
		random() - 0.5;
		random() - 0.5;
	};
	return random() * 10 ** q.normalized;
}

