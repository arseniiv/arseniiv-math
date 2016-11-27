"Math library currently providing basic support of
 [[complex numbers|https://en.wikipedia.org/wiki/Complex_number]]
 and [[quaternions|http://en.wikipedia.org/Quaternion]].
 
 This module contains only common stuff like [[Float]] constants
 and functions. All else is in sister modules:
 
 * [[module name.arseniiv.math.complex]]
 * [[module name.arseniiv.math.quaternion]]"
license("http://opensource.org/licenses/MIT")
by("arseniiv")
module name.arseniiv.math.core "0.1.3" {
	import ceylon.numeric "1.3.1";
	native("jvm") import java.base "8";
}
