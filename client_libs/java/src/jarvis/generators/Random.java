package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;

public class Random extends Jarvis {
    public Random(String host, int port) throws JarvisException {
        super(host, port);
    }

    public Random(String host) throws JarvisException {
        super(host);
    }

    public Random() throws JarvisException {
        super();
    }
}
