"Tests for `name.arseniiv.math.core` (none currently) and
 utilities for other modules’ tests."
by("arseniiv")
module test.name.arseniiv.math.core "0.1.3" {
	import ceylon.numeric "1.3.1";
	import ceylon.test "1.3.1";
	native("jvm") import java.base "8";
	shared import name.arseniiv.math.core "0.1.3";
}
