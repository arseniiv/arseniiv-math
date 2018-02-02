"Math library currently providing basic support of
 [rational numbers](https://en.wikipedia.org/wiki/Rational_number), 
 [complex numbers](https://en.wikipedia.org/wiki/Complex_number)
 and [quaternions](https://en.wikipedia.org/Quaternion).
 
 See packages’ documentation and `README.md`."
license("http://opensource.org/licenses/MIT")
by("arseniiv")
module name.arseniiv.math "0.1.5" {
	native("jvm") import java.base "8";
	value ceylonVersion = "1.3.3";
	import ceylon.numeric ceylonVersion;
	import ceylon.collection ceylonVersion;
	shared import ceylon.whole ceylonVersion;
}
