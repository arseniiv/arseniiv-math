import java.lang {
	JDouble=Double
}

shared native Float minNormalFloat = 2.22507385850720138e-308;

shared native("jvm") Float minNormalFloat = JDouble.\iMIN_NORMAL;
