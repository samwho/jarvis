package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;

public class Scale extends Jarvis {
    public Scale(String host, int port) throws JarvisException {
        super(host, port);
    }

    public Scale(String host) throws JarvisException {
        super(host);
    }

    public Scale() throws JarvisException {
        super();
    }
}
