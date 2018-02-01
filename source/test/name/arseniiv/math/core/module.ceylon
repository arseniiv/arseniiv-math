"Tests for `name.arseniiv.math.core` and
 utilities for other modules’ tests."
by("arseniiv")
module test.name.arseniiv.math.core "0.1.4" {
	import ceylon.numeric "1.3.3";
	import ceylon.test "1.3.3";
	native("jvm") import java.base "8";
	shared import name.arseniiv.math.core "0.1.4";
}
