import ceylon.math.float {
	pi
}

"Sign of `x` represented as `'+'` or `'-'` character."
shared Character signChar(Float x) => x >= 0.0 then '+' else '-';

"`τ == 2π`"
shared Float tau = 2.0 * pi;
