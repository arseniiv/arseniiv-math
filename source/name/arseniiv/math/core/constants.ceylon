import ceylon.numeric.float {
	pi
}

"Constant tau `τ = 2π ≈ 6.28`,
 the period of cosine and sine functions."
shared Float tau = 2.0 * pi;

"Radian measure of angle equivalent to 1°.
 You can use it to sensibly denote degree angle values:
 
     value rightAngle = 90 * degrees; // indeed 90°
     value hexagonAngle = 120 * degrees; // and so on…"
shared Float degrees = pi / 180.0;
