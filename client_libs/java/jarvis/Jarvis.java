package jarvis;

import java.net.Socket;
import java.net.UnknownHostException;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.InputStreamReader;

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
            out.print(message);
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

            return new String(buffer, 0, offset);
        } catch (IOException e) {
            throw new JarvisException(e);
        }
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
    public void start() throws JarvisException {
        this.sendMessage("start");
    }

    /**
     * Tells the server to stop playing music.
     */
    public void stop() throws JarvisException {
        this.sendMessage("stop");
    }
}

