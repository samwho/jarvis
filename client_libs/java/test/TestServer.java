import static org.junit.Assert.*;
import org.junit.Test;
import org.junit.Before;
import org.junit.After;
import helpers.ServerHelper;
import jarvis.exceptions.JarvisException;

public class TestServer extends ServerHelper {
    @Test
    public void testVolume() throws JarvisException {
        assertEquals(100, jarvis.getVolume());
    }

    @Test
    public void testSetVolume() throws JarvisException {
        assertEquals(20, jarvis.setVolume(20));
    }

    @Test
    public void testVolumeUp() throws JarvisException {
        assertEquals(105, jarvis.volumeUp());
    }

    @Test
    public void testVolumeDown() throws JarvisException {
        assertEquals(95, jarvis.volumeDown());
    }

    @Test
    public void testTempo() throws JarvisException {
        assertEquals(80, jarvis.getTempo());
    }

    @Test
    public void testSetTempo() throws JarvisException {
        assertEquals(20, jarvis.setTempo(20));
    }

    @Test
    public void testTempoUp() throws JarvisException {
        assertEquals(85, jarvis.tempoUp());
    }

    @Test
    public void testTempoDown() throws JarvisException {
        assertEquals(75, jarvis.tempoDown());
    }

    @Test(expected = JarvisException.class)
    public void testNoCommandFound() throws JarvisException {
        jarvis.sendMessage("definitelynotacommandatall");
    }

    @Test(expected = JarvisException.class)
    public void testGeneratorCommandGeneratorNotLoaded() throws JarvisException {
        jarvis.loadGenerator("Random");
        jarvis.sendMessage("Otomata.poke 1 1");
    }

    @Test
    public void testListGenerators() throws JarvisException {
        String[] list = jarvis.getGenerators();
        assertTrue(list.length > 0);
    }

    @Test
    public void testStart() throws JarvisException {
        String response = jarvis.start();
        assertTrue(response.contains("successfully"));
    }

    @Test
    public void testStop() throws JarvisException {
        jarvis.start();
        String response = jarvis.stop();
        assertTrue(response.contains("successfully"));
    }
}
