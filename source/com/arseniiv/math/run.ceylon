import ceylon.math.float { pi }
import com.arseniiv.math.quaternion { ... }

"Run the module `com.arseniiv.math`."
void run() {
	value v = Quaternion(0.0, 1.0, 2.0, 3.0);
	value r = makeRotor(Quaternion(0.0, 0.0, 1.0, 0.0), pi/2);
	value v2 = v.rotate(r);
	print("v = ``v``");
	print("r = ``r``");
	print("r * v * r* = ``v2``");
}