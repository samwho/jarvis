package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;

public class MarkhovChains extends AbstractGenerator {
    public MarkhovChains(String host, int port) throws JarvisException {
        super(host, port);
    }

    public MarkhovChains(String host) throws JarvisException {
        super(host);
    }

    public MarkhovChains(Jarvis j) throws JarvisException {
        super(j);
    }

    public MarkhovChains() throws JarvisException {
        super();
    }
}
