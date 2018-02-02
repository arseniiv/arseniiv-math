"Unit tests for `name.arseniiv.math`."
license("http://opensource.org/licenses/MIT")
by("arseniiv")
module test.name.arseniiv.math "0.1.5" {
	native("jvm") import java.base "8";
	value ceylonVersion = "1.3.3";
	import ceylon.numeric ceylonVersion;
	import ceylon.test ceylonVersion;
	import name.arseniiv.math "0.1.5";
}
