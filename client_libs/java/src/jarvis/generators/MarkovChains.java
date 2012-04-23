package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;

public class MarkovChains extends Jarvis {
    public MarkovChains(String host, int port) throws JarvisException {
        super(host, port);
    }

    public MarkovChains(String host) throws JarvisException {
        super(host);
    }

    public MarkovChains() throws JarvisException {
        super();
    }
}
