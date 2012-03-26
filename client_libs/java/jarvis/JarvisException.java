package jarvis;

public class JarvisException extends Exception {
    public JarvisException(String message) {
        super(message);
    }

    public JarvisException(Throwable t) {
        super(t);
    }

    public JarvisException(String message, Throwable t) {
        super(message, t);
    }
}
