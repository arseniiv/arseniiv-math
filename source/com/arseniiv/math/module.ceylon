"Math library currently providing basic support of
 [[complex numbers|https://en.wikipedia.org/wiki/Complex_number]]
 and [[quaternions|http://en.wikipedia.org/Quaternion]].
 
 The code will use new features of Ceylon 1.2
 after release of the latter. ;)"
license("http://opensource.org/licenses/MIT")
by("arseniiv")
native("jvm") module com.arseniiv.math "0.1.0" {
	native("jvm") import ceylon.math "1.1.1";
}
