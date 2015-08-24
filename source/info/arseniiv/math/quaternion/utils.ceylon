"Returns `2u × v`."
by("arseniiv")
Quaternion vectorMult2(Float[3] u, Float[3] v) {
	//value [ux, uy, uz] = u;
	//value [vx, vy, vz] = v;
	value ux = u[0];
	value uy = u[1];
	value uz = u[2];
	value vx = v[0];
	value vy = v[1];
	value vz = v[2];
	value x = uy * vz - uz * vy;
	value y = uz * vx - ux * vz;
	value z = ux * vy - uy * vx;
	return Quaternion(0.0, 2.0 * x, 2.0 * y, 2.0 * z);
}

"Returns `s * v + u × v`."
by("arseniiv")
Float[3] scalarVectorMult(Float s, Float[3] u, Float[3] v) {
	//value [ux, uy, uz] = u;
	//value [vx, vy, vz] = v;
	value ux = u[0];
	value uy = u[1];
	value uz = u[2];
	value vx = v[0];
	value vy = v[1];
	value vz = v[2];
	value x = s * vx + uy * vz - uz * vy;
	value y = s * vy + uz * vx - ux * vz;
	value z = s * vz + ux * vy - uy * vx;
	return [x, y, z];
}