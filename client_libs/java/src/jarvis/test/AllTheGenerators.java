package jarvis.test;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;
import jarvis.generators.*;

public class AllTheGenerators {
    public static void main(String[] args) {
        try {
            // Initialise ALL the generators|
            Random r = new Random();
            MarkhovChains m = new MarkhovChains();
            Otomata o = new Otomata();
            Scale s = new Scale();
            CellularAutonoma c = new CellularAutonoma();

            r.start();
            Thread.sleep(5000);
            r.stop();

            m.start();
            Thread.sleep(5000);
            m.stop();

            o.start();
            Thread.sleep(5000);
            o.stop();

            s.start();
            Thread.sleep(5000);
            s.stop();

            c.start();
            Thread.sleep(5000);
            c.stop();
        } catch (JarvisException je) {
            System.out.println(je.getMessage());
        } catch (InterruptedException ie) {
            System.out.println(ie.getMessage());
        }
    }
}
