"Tests for `info.arseniiv.math`."
native("jvm") module test.info.arseniiv.math "0.1.0" {
	import ceylon.test "1.1.1";
	native("jvm") import ceylon.math "1.1.1";
	native("jvm") import java.base "8";
	shared import info.arseniiv.math "0.1.0";
}
