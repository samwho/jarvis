package jarvis.test;

import jarvis.Jarvis;
import jarvis.generators.Otomata;

/**
 * This class is just used for impromptu testing of the rest of the Java Jarvis
 * client library as and when new things are being added.
 */
class JarvisTest {
    public static void main(String[] args) {
        try {
            Jarvis j = new Jarvis("localhost");
            Otomata o = new Otomata(j);

            o.load();

            j.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
