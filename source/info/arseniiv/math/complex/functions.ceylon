import com.vasileff.ceylon.xmath.float {
	fexp=exp,
	fcos=cos,
	fsin=sin,
	fcosh=cosh,
	fsinh=sinh,
	flog=log
}

import info.arseniiv.math {
	tau
}

"Exponent of a complex number."
by("arseniiv")
shared Complex exp(Complex z) =>
		Complex.fromPolar(fexp(z.re), z.im);

"Logarithm of a complex number.
 
 Complex logarithm is a multivalued function.
 Here we are returning a principal(?) value only."
by("arseniiv")
shared Complex log(Complex z) {
	return Complex(flog(z.magnitude), z.argument);
}

"Cosine and sine of a complex number.
 
 Runs faster than separate calls to [[cos]] and [[sin]]."
by("arseniiv")
shared Complex[2] cosSin(Complex z) {
	value re = z.re;
	value im = z.im;
	return [
		Complex(fcos(re) * fcosh(im), -fsin(re) * fsinh(im)),
		Complex(fsin(re) * fcosh(im),  fcos(re) * fsinh(im))
	];
}

"Cosine of a complex number."
by("arseniiv")
see(`function cosSin`)
shared Complex cos(Complex z) {
	value re = z.re;
	value im = z.im;
	return Complex(fcos(re) * fcosh(im), -fsin(re) * fsinh(im));
}

"Sine of a complex number."
by("arseniiv")
see(`function cosSin`)
shared Complex sin(Complex z) {
	value re = z.re;
	value im = z.im;
	return Complex(fsin(re) * fcosh(im),  fcos(re) * fsinh(im));
}

"Hyperbolic cosine and sine of a complex number.
 
 Runs faster than separate calls to [[cosh]] and [[sinh]]."
by("arseniiv")
shared Complex[2] coshSinh(Complex z) {
	value re = z.re;
	value im = z.im;
	return [
		Complex(fcosh(re) * fcos(im), fsinh(re) * fsin(im)),
		Complex(fsinh(re) * fcos(im), fcosh(re) * fsin(im))
	];
}

"Hyperbolic cosine of a complex number."
by("arseniiv")
see(`function coshSinh`)
shared Complex cosh(Complex z) {
	value re = z.re;
	value im = z.im;
	return Complex(fcosh(re) * fcos(im), fsinh(re) * fsin(im));
}

"Hyperbolic sine of a complex number."
by("arseniiv")
see(`function coshSinh`)
shared Complex sinh(Complex z) {
	value re = z.re;
	value im = z.im;
	return Complex(fsinh(re) * fcos(im), fcosh(re) * fsin(im));
}

"`(index % n)`-th solution of an equation `w^n == z`."
by("arseniiv")
shared Complex root(Complex z, Integer n, Integer index = 0) {
	"`n` must be positive number"
	assert (n.positive);
	value overN = 1.0 / n;
	value mag = z.magnitude^overN;
	value arg = (z.argument + tau * index) * overN;
	return Complex.fromPolar(mag, arg);
}

"All solutions of an equation `w^n == z`."
by("arseniiv")
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

"Sesquilinear dot product `z . w = z* w`"
by("arseniiv")
Complex dot(Complex z, Complex w) => Complex {
	re = z.re * w.re + z.im * w.im;
	im = z.re * w.im - z.im * w.re;
};


