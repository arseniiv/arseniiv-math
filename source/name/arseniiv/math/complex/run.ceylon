import name.arseniiv.math.complex {
	...
}

"Run the module `name.arseniiv.math.complex`."
void run() {
	value a = Complex.infinity;
	value b = Complex.zero;
	print("a = ``a``");
	print("a^-1 = ``a.inverse``");
	print("a.arg = ``a.argument``");
	print("a.infinite = ``a.infinite``");
	print("a.finite = ``a.finite``");
	print("b = ``b``");
	print("b^-1 = ``b.inverse``");
	print("b.arg = ``b.argument``");
}
