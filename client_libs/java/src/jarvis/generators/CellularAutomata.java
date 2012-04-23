package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;

public class CellularAutomata extends Jarvis {
    public CellularAutomata(String host, int port) throws JarvisException {
        super(host, port);
    }

    public CellularAutomata(String host) throws JarvisException {
        super(host);
    }

    public CellularAutomata() throws JarvisException {
        super();
    }
}
