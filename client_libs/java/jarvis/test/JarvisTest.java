package jarvis.test;

import jarvis.Jarvis;

class JarvisTest {
    public static void main(String[] args) {
        try {
            Jarvis j = new Jarvis("localhost");

            j.loadGenerator("Random");
            j.start();
            Thread.sleep(5000);
            j.stop();

            j.loadGenerator("MarkhovChains");
            j.start();
            Thread.sleep(5000);
            j.stop();

            j.loadGenerator("Scale");
            j.start();
            Thread.sleep(5000);
            j.stop();

            j.loadGenerator("CellularAutonoma");
            j.start();
            Thread.sleep(5000);
            j.stop();

            j.close();
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
