"Math library currently providing basic support of
 [[complex numbers|https://en.wikipedia.org/wiki/Complex_number]]
 and [[quaternions|http://en.wikipedia.org/Quaternion]].
 
 The code will use much more of Ceylon 1.2 new features
 after release of the latter. ;)"
license("http://opensource.org/licenses/MIT")
by("arseniiv")
native("jvm") module info.arseniiv.math "0.1.0" {
	native("jvm") import ceylon.math "1.1.1";
}
