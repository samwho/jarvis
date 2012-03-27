package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;

public class Random extends AbstractGenerator {
    public Random(String host, int port) throws JarvisException {
        super(host, port);
    }

    public Random(String host) throws JarvisException {
        super(host);
    }

    public Random(Jarvis j) throws JarvisException {
        super(j);
    }

    public Random() throws JarvisException {
        super();
    }
}
