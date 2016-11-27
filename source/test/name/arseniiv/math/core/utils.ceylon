import name.arseniiv.math.core {
	nearlyEquals
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
		floatsBy(nearlyEquals(1.0));

"Comparison of sequences using given function elementwise."
shared Boolean sequencesBy<Value>(Boolean(Value, Value) f)(Anything x, Anything y) {
	if (is [Value*] x, is [Value*] y) {
		if (x.size != y.size) { return false; }
		return every { for ([xe, ye] in zipPairs(x, y)) f(xe, ye) };
	}
	else { return false; }
}
