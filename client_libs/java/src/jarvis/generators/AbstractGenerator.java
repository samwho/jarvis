package jarvis.generators;

import jarvis.Jarvis;
import jarvis.exceptions.JarvisException;
import java.io.IOException;

public abstract class AbstractGenerator {
    protected Jarvis jarvis;

    /**
     * Sub classes of this abstract generator should try and ensure that they
     * always call this constructor with a valid Jarvis object when they are
     * creating new constructors.
     *
     * This constructor takes the Jarvis object passed in and stores it into a
     * protected variable called "jarvis", ready for use in later methods.
     *
     * It also loads this generator up automatically. The design decision that
     * was made here is that generator specific methods will not work unless
     * that generator has been loaded. This may be confusing to people who write
     * code that looks like this:
     *
     *      Otomata o = new Otomata(new Jarvis("localhost"));
     *      o.poke(1, 1);
     *
     * And get a JarvisException.
     */
    public AbstractGenerator(Jarvis j) throws JarvisException {
        this.jarvis = j;
        load();
    }

    /**
     * This method will load the current generator on the Jarvis object that was
     * passed into the constructor.
     *
     * This method uses the Java class name to load the generator. Because of
     * this, the Java class name must exactly match the name of the generator.
     */
    public void load() throws JarvisException {
        jarvis.loadGenerator(this.getClass().getSimpleName());
    }

    /**
     * Closes the internal Jarvis object.
     */
    public void close() throws IOException {
        jarvis.close();
    }

    /**
     * Calls the start method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public void start() throws JarvisException {
        jarvis.start();
    }

    /**
     * Calls the stop method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public void stop() throws JarvisException {
        jarvis.stop();
    }

    /**
     * Calls the volumeUp method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public int volumeUp() throws JarvisException {
        return jarvis.volumeUp();
    }

    /**
     * Calls the volumeDown method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public int volumeDown() throws JarvisException {
        return jarvis.volumeDown();
    }

    /**
     * Calls the getVolume method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public int getVolume() throws JarvisException {
        return jarvis.getVolume();
    }

    /**
     * Calls the setVolume method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public int setVolume(int volume) throws JarvisException {
        return jarvis.setVolume(volume);
    }

    /**
     * Calls the tempoUp method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public int tempoUp() throws JarvisException {
        return jarvis.tempoUp();
    }

    /**
     * Calls the tempoDown method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public int tempoDown() throws JarvisException {
        return jarvis.tempoDown();
    }

    /**
     * Calls the getTempo method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public int getTempo() throws JarvisException {
        return jarvis.getTempo();
    }

    /**
     * Calls the setTempo method on the underlying Jarvis object. Essentially this
     * is just a delegation function.
     *
     * @see jarvis.Jarvis
     */
    public int setTempo(int tempo) throws JarvisException {
        return jarvis.setTempo(tempo);
    }
}
