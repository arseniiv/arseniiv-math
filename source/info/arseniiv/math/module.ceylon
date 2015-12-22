"Math library currently providing basic support of
 [[complex numbers|https://en.wikipedia.org/wiki/Complex_number]]
 and [[quaternions|http://en.wikipedia.org/Quaternion]].
 
 The code will use much more of Ceylon 1.2 new features
 after release of the latter. ;)"
license("http://opensource.org/licenses/MIT")
by("arseniiv")
module info.arseniiv.math "0.1.1" {
	import com.vasileff.ceylon.xmath "0.0.1";
	//native("jvm") import ceylon.math "1.2.0"; // until no longer native("jvm")
}
