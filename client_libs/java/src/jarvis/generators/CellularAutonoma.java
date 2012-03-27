package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;

public class CellularAutonoma extends AbstractGenerator {
    public CellularAutonoma(String host, int port) throws JarvisException {
        super(host, port);
    }

    public CellularAutonoma(String host) throws JarvisException {
        super(host);
    }

    public CellularAutonoma(Jarvis j) throws JarvisException {
        super(j);
    }

    public CellularAutonoma() throws JarvisException {
        super();
    }
}
