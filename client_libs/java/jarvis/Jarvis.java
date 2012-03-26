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

    public Jarvis(String host) throws JarvisException {
        this(host, 1337);
    }

    public String sendMessage(String message) throws JarvisException {
        int offset;
        int numread;

        try {
            out.print(message);
            out.flush();

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

    public void start() throws JarvisException {
        this.sendMessage("start");
    }

    public void stop() throws JarvisException {
        this.sendMessage("stop");
    }
}

