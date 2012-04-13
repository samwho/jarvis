package jarvis.generators;

import jarvis.exceptions.JarvisException;
import jarvis.Jarvis;

public class Otomata extends Jarvis {
  public static int NONE = 0;
  public static int UP = 1;
  public static int DOWN = 2;
  public static int LEFT = 4;
  public static int RIGHT = 8;

  public Otomata(String host, int port) throws JarvisException {
    super(host, port);
  }

  public Otomata(String host) throws JarvisException {
    super(host);
  }

  public Otomata() throws JarvisException {
    super();
  }

  public int poke(int x, int y) throws JarvisException {
    String response = this.sendGeneratorMessage("poke " + x + " " + y);
    if (response.startsWith("Invalid co-ordinates")) {
      throw new JarvisException(response);
    } else if (response.endsWith("up.")) {
      return UP;
    } else if (response.endsWith("right.")) {
      return RIGHT;
    } else if (response.endsWith("down.")) {
      return DOWN;
    } else if (response.endsWith("left.")) {
      return LEFT;
    } else if (response.endsWith("none.")) {
      return NONE;
    } else {
      throw new JarvisException(response);
    }
  }
}
