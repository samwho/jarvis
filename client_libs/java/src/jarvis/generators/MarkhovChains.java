package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;

public class MarkhovChains extends Jarvis {
    public MarkhovChains(String host, int port) throws JarvisException {
        super(host, port);
    }

    public MarkhovChains(String host) throws JarvisException {
        super(host);
    }

    public MarkhovChains() throws JarvisException {
        super();
    }
}
