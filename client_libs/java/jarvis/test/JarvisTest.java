package jarvis.test;

import jarvis.Jarvis;

class JarvisTest {
    public static void main(String[] args) {
        try {
            Jarvis j = new Jarvis("localhost");
            j.start();
            Thread.sleep(4000);
            j.stop();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
