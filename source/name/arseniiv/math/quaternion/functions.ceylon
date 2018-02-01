import ceylon.numeric.float {
	fexp=exp,
	fcos=cos,
	fsin=sin,
	fcosh=cosh,
	fsinh=sinh,
	atan2,
	flog=log
}

"Exponent of a quaternion."
shared Quaternion exp(Quaternion q) {
	value v = q.vec;
	value vmag = v.magnitude;
	return fexp(q.re) ** (Quaternion(fcos(vmag)) +
			fsin(vmag) ** v.normalized);
}

"Logarithm of a quaternion.
 
 Quaternion logarithm is a multivalued function.
 Here we are returning a principal(?) value only."
shared Quaternion log(Quaternion q) {
	value v = q.vec;
	value angle = atan2(v.magnitude, q.re);
	// return Quaternion(flog(q.magnitude)) + angle ** v.normalized;
	return Quaternion(0.5 * flog(q.magnitudeSqr)) + angle ** v.normalized;
}

"Cosine and sine of a quaternion.
 
 Runs faster than separate calls to [[cos]] and [[sin]]."
shared Quaternion[2] cosSin(Quaternion q) {
	value re = q.re;
	value v = q.vec;
	value vmag = v.magnitude;
	value n = v.normalized;
	return [
		Quaternion(fcos(re) * fcosh(vmag)) - fsin(re) * fsinh(vmag) ** n,
		Quaternion(fsin(re) * fcosh(vmag)) + fcos(re) * fsinh(vmag) ** n
	];
}

"Cosine of a quaternion."
see(`function cosSin`)
shared Quaternion cos(Quaternion q) {
	value re = q.re;
	value v = q.vec;
	value vmag = v.magnitude;
	value n = v.normalized;
	return Quaternion(fcos(re) * fcosh(vmag)) - fsin(re) * fsinh(vmag) ** n;
}

"Sine of a quaternion."
see(`function cosSin`)
shared Quaternion sin(Quaternion q) {
	value re = q.re;
	value v = q.vec;
	value vmag = v.magnitude;
	value n = v.normalized;
	return Quaternion(fsin(re) * fcosh(vmag)) + fcos(re) * fsinh(vmag) ** n;
}

"Hyperbolic cosine and sine of a quaternion.
 
 Runs faster than separate calls to [[cosh]] and [[sinh]]."
shared Quaternion[2] coshSinh(Quaternion q) {
	value re = q.re;
	value v = q.vec;
	value vmag = v.magnitude;
	value n = v.normalized;
	return [
		Quaternion(fcosh(re) * fcos(vmag)) + fsinh(re) * fsin(vmag) ** n,
		Quaternion(fsinh(re) * fcos(vmag)) + fcosh(re) * fsin(vmag) ** n
	];
}

"Hyperbolic cosine of a quaternion."
see(`function coshSinh`)
shared Quaternion cosh(Quaternion q) {
	value re = q.re;
	value v = q.vec;
	value vmag = v.magnitude;
	value n = v.normalized;
	return Quaternion(fcosh(re) * fcos(vmag)) + fsinh(re) * fsin(vmag) ** n;
}

"Hyperbolic sine of a quaternion."
see(`function coshSinh`)
shared Quaternion sinh(Quaternion q) {
	value re = q.re;
	value v = q.vec;
	value vmag = v.magnitude;
	value n = v.normalized;
	return Quaternion(fsinh(re) * fcos(vmag)) + fcosh(re) * fsin(vmag) ** n;
}

"Spherical linear interpolation (SLERP) between rotors."
see(`function Quaternion.rotor`)
shared Quaternion(Float) slerp(Quaternion rotor1, Quaternion rotor2) {
	value quotient = rotor1.conjugate * rotor2;
	function interpolator(Float t) => rotor1 * quotient^t;
	return interpolator;
}
