import ceylon.numeric.float {
	fexp=exp,
	fcos=cos,
	fsin=sin,
	fcosh=cosh,
	fsinh=sinh,
	flog=log,
	fsqrt=sqrt
}

import name.arseniiv.math.core {
	tau
}

"Exponent of a complex number."
shared Complex exp(Complex z) =>
		Complex.fromPolar(fexp(z.re), z.im);

"Logarithm of a complex number.
 
 Complex logarithm is a multivalued function.
 Here we are returning a principal(?) value only."
shared Complex log(Complex z) {
	return Complex(flog(z.magnitude), z.argument);
}

"Cosine and sine of a complex number.
 
 Runs faster than separate calls to [[cos]] and [[sin]]."
shared Complex[2] cosSin(Complex z) {
	value re = z.re;
	value im = z.im;
	return [
		Complex(fcos(re) * fcosh(im), -fsin(re) * fsinh(im)),
		Complex(fsin(re) * fcosh(im),  fcos(re) * fsinh(im))
	];
}

"Cosine of a complex number."
see(`function cosSin`)
shared Complex cos(Complex z) {
	value re = z.re;
	value im = z.im;
	return Complex(fcos(re) * fcosh(im), -fsin(re) * fsinh(im));
}

"Sine of a complex number."
see(`function cosSin`)
shared Complex sin(Complex z) {
	value re = z.re;
	value im = z.im;
	return Complex(fsin(re) * fcosh(im),  fcos(re) * fsinh(im));
}

"Hyperbolic cosine and sine of a complex number.
 
 Runs faster than separate calls to [[cosh]] and [[sinh]]."
shared Complex[2] coshSinh(Complex z) {
	value re = z.re;
	value im = z.im;
	return [
		Complex(fcosh(re) * fcos(im), fsinh(re) * fsin(im)),
		Complex(fsinh(re) * fcos(im), fcosh(re) * fsin(im))
	];
}

"Hyperbolic cosine of a complex number."
see(`function coshSinh`)
shared Complex cosh(Complex z) {
	value re = z.re;
	value im = z.im;
	return Complex(fcosh(re) * fcos(im), fsinh(re) * fsin(im));
}

"Hyperbolic sine of a complex number."
see(`function coshSinh`)
shared Complex sinh(Complex z) {
	value re = z.re;
	value im = z.im;
	return Complex(fsinh(re) * fcos(im), fcosh(re) * fsin(im));
}

"`(index % n)`-th solution of an equation `w^n == z`."
see(`function sqrt`)
see(`function roots`)
shared Complex root(Complex z, Integer n, Integer index = 0) {
	"`n` must be positive number"
	assert (n.positive);
	value overN = 1.0 / n;
	value mag = z.magnitude^overN;
	value arg = (z.argument + tau * index) * overN;
	return Complex.fromPolar(mag, arg);
}

"All solutions of an equation `w^n == z`."
see(`function root`)
shared {Complex+} roots(Complex z, Integer n) {
	"`n` must be positive number"
	assert (n.positive);
	value overN = 1.0 / n;
	value mag = z.magnitude^overN;
	value arg = z.argument * overN;
	value arg2 = tau * overN;
	value multiplier = Complex.fromPolarUnit(arg2);
	
	return object satisfies {Complex+} {
		shared actual Iterator<Complex> iterator() =>
				object satisfies Iterator<Complex> {
					variable value index = n;
					variable value current = Complex.fromPolar(mag, arg);
					shared actual Complex|Finished next() {
						if (index == 0) { return finished; }
						index--;
						value res = current;
						current *= multiplier;
						return res;
					}
				};
	};
}

"One of the square roots `w` of `z`, the other being `−w`."
see (`function root`)
shared Complex sqrt(Complex z) {
	if (z.re == 0.0 && z.im == 0.0) { return Complex.zero; }
	value mag = z.magnitude;
	value re = z.re;
	value a = fsqrt(2 * (mag + re.magnitude));
	return if (re >= 0.0)
		then Complex(0.5 * a, z.im / a)
		else Complex(z.im / a, 0.5 * a);
}

"Solve quadratic equation
 
     a z^2 + b z + c == 0.
 
 You can safely pass `0` or near-zero values for `a`.
 In this case, the only root `-c / b` is returned.
 
 You can also safely pass `b` close to zero. If `a` and `b` are both too close,
 `[]` is returned, which may signify there are no or infinitely many solutions.
 
 Otherwise, two roots are returned, even if they coincide."
shared []|Complex[1]|Complex[2] solveQuadratic(Complex a, Complex b, Complex c) {
	value ainv = a.inverse;
	value ba = -0.5 ** b * ainv;
	value baSqr = ba * ba;
	value ca = c * ainv;
	if (baSqr.finite && ca.finite) {
		value d = sqrt(baSqr - ca);
		return [ba - d, ba + d];
	}
	else {
		value binv = b.inverse;
		value z = -c * binv;
		return if (binv.infinite || z.infinite) then [] else [z];
	}
}

"Sesquilinear dot product `z . w = z* w`"
shared Complex dot(Complex z, Complex w) => Complex {
	re = z.re * w.re + z.im * w.im;
	im = z.re * w.im - z.im * w.re;
};


