package helpers;

import static org.junit.Assume.*;
import org.junit.Before;
import org.junit.After;
import jarvis.*;
import jarvis.exceptions.*;
import java.io.IOException;
import java.io.BufferedInputStream;

public class ServerHelper {
  public Process serverProcess;
  public BufferedInputStream serverStdOut;
  public Jarvis jarvis;

  @Before
  public void setUp() {
    try {
      serverProcess = Runtime.getRuntime().exec("jarvis --testing");
      serverStdOut  = new BufferedInputStream(serverProcess.getInputStream());
      // Give the server some time to boot. Dirty, I know, but I can't
      // think of any better way of doing this at the moment.
      Thread.sleep(1000);
      jarvis = new Jarvis();
    } catch (SecurityException e) {
      System.out.println("SecurityException in setUp: " + e.getMessage());
    } catch (IOException e) {
      System.out.println("IOException in setUp: " + e.getMessage());
    } catch (JarvisException e) {
      System.out.println("JarvisException in setUp: " + e.getMessage());
    } catch (Exception e) {
      System.out.println("Exception in setUp: " + e.getMessage());
    }

    assumeNotNull(serverProcess);
    assumeNotNull(jarvis);
  }

  @After
  public void tearDown() throws Exception {
    if (jarvis != null)
      jarvis.killServer();

    if (serverStdOut != null)
      serverStdOut.close();

    if (serverProcess != null)
      serverProcess = null;
  }
}
