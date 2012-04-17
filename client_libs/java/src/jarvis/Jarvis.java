package jarvis;

import java.net.Socket;
import java.net.UnknownHostException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import jarvis.exceptions.JarvisException;

public class Jarvis {
    private Socket conn;
    private PrintWriter out;
    private BufferedReader server;
    private char[] buffer;
    private int bufsize = 4096;
    private int chunksize = 512;

    /**
     * Initialise Jarvis with a host name and a port number.
     *
     * If the port is not supplied it will default to Jarvis's default port
     * number of 1337.
     *
     * If there is no Jarvis server running, a JarvisException will be thrown.
     */
    public Jarvis(String host, int port) throws JarvisException {
        try {
            conn = new Socket(host, port);
            out = new PrintWriter(conn.getOutputStream(), true);
            server = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            buffer = new char[bufsize];

            // If the current class is not called Jarvis, load it.
            if (!this.getClass().getSimpleName().equals("Jarvis"))
                this.loadGenerator(this.getClass().getSimpleName());
        } catch (UnknownHostException uhe) {
            throw new JarvisException("Could not connect to " + host + ":" + port, uhe);
        } catch (IOException ioe) {
            throw new JarvisException(ioe);
        }
    }

    /**
     * Initialise Jarvis with just a host name and the default port number of
     * 1337.
     *
     * If there is no Jarvis server running, a JarvisException will be thrown.
     */
    public Jarvis(String host) throws JarvisException {
        this(host, 1337);
    }

    /**
     * Initialise Jarvis with the host name "localhost" and the port number
     * 1337.
     *
     * If there is no Jarvis server running, a JarvisException will be thrown.
     */
    public Jarvis() throws JarvisException {
        this("localhost", 1337);
    }

    /**
     * Sends a string message directly to the current Jarvis server. This is
     * the method that is used for other calls in this library such as
     * "getGenerators". If you need to send something a bit custom to the Jarvis
     * server because there is currently no library support for it, this is the
     * method to use.
     *
     * @return String If the server returned a message from the command you just
     * sent to it, this message will be returned from this method.
     */
    public String sendMessage(String message) throws JarvisException {
        int offset;
        int numread;

        try {
            out.print(message + ";");
            out.flush();

            /*
             * This for loop is a little fiddly. Basically, when reading from a
             * socket you can't just use readLine because that will block when
             * it reaches the end of the input. You have to use read and check
             * how many bytes it has read, returning if it's less bytes than you
             * asked for.
             */
            for (offset = 0, numread = 0; offset < bufsize; offset += chunksize) {
                if ((numread = server.read(buffer, offset, chunksize)) == -1) {
                    break;
                } else if (numread < chunksize) {
                    offset += numread;
                    break;
                }
            }

            String toReturn = new String(buffer, 0, offset);

            if (toReturn.startsWith("ERROR: ")) {
                throw new JarvisException(toReturn.trim());
            } else {
                return toReturn.trim();
            }
        } catch (IOException e) {
            throw new JarvisException(e);
        }
    }

    /**
     * Because generators take commands in the format:
     *
     *    GeneratorName.command_name args
     *
     * This method automatically prepends the GeneratorName part, making it
     * easier for subclasses of this class to send generator commands.
     */
    public String sendGeneratorMessage(String message) throws JarvisException {
        String className = this.getClass().getSimpleName();
        return this.sendMessage(className + "." + message);
    }

    /**
     * This method will return a string list of the available generators on the
     * Jarvis server that you are connected to.
     */
    public String[] getGenerators() throws JarvisException {
        return this.sendMessage("generators").split("/\n/");
    }

    /**
     * Tells the server to start playing music.
     */
    public String start() throws JarvisException {
        return this.sendMessage("start");
    }

    /**
     * Tells the server to stop playing music.
     */
    public String stop() throws JarvisException {
        return this.sendMessage("stop");
    }

    /**
     * This method will completely shut down the server process. Use with
     * extreme caution.
     */
    public void killServer() throws JarvisException {
        this.sendMessage("kill_server");
    }

    /**
     * Load a generator by name. If the generator does not exist, an exception
     * will be thrown.
     */
    public void loadGenerator(String generator) throws JarvisException {
        this.sendMessage("load " + generator);
    }

    /**
     * Increases the volume on the Jarvis server.
     *
     * @return int New volume.
     */
    public int volumeUp() throws JarvisException {
        return Integer.parseInt(this.sendMessage("volume up"));
    }

    /**
     * Decreases the volume on the Jarvis server.
     *
     * @return int New volume.
     */
    public int volumeDown() throws JarvisException {
        return Integer.parseInt(this.sendMessage("volume down"));
    }

    /**
     * Sets the volume on the Jarvis server. Be careful with values over 100.
     *
     * @return int New volume.
     */
    public int setVolume(int volume) throws JarvisException {
        return Integer.parseInt(this.sendMessage("volume " + volume));
    }

    /**
     * Gets the current volume from the Jarvis server.
     *
     * @return int Current volume.
     */
    public int getVolume() throws JarvisException {
        return Integer.parseInt(this.sendMessage("volume"));
    }

    /**
     * Increases the tempo on the Jarvis server.
     *
     * @return int New tempo.
     */
    public int tempoUp() throws JarvisException {
        return Integer.parseInt(this.sendMessage("tempo up"));
    }

    /**
     * Decreases the tempo on the Jarvis server.
     *
     * @return int New tempo.
     */
    public int tempoDown() throws JarvisException {
        return Integer.parseInt(this.sendMessage("tempo down"));
    }

    /**
     * Sets the tempo on the Jarvis server.
     *
     * @return int New tempo.
     */
    public int setTempo(int tempo) throws JarvisException {
        return Integer.parseInt(this.sendMessage("tempo " + tempo));
    }

    /**
     * Gets the current volume from the Jarvis server.
     *
     * @return int Current volume.
     */
    public int getTempo() throws JarvisException {
        return Integer.parseInt(this.sendMessage("tempo"));
    }

    /**
     * Closes all of the opened sockets and readers for this Jarvis server. Must
     * be called if you wish to discard of a Jarvis object.
     */
    public void close() throws IOException {
        conn.close();
        out.close();
        server.close();
    }
}
