package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;

public class CellularAutonoma extends Jarvis {
    public CellularAutonoma(String host, int port) throws JarvisException {
        super(host, port);
    }

    public CellularAutonoma(String host) throws JarvisException {
        super(host);
    }

    public CellularAutonoma() throws JarvisException {
        super();
    }
}
