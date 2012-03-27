package jarvis.examples;

import jarvis.*;
import jarvis.exceptions.*;
import jarvis.generators.*;
import java.io.IOException;

public class Usage {
    public static void main(String[] args) {
        try {
            /*
             * This is how you create a connection to a Jarvis server. By default,
             * when you pass in no parameters it will try to connect to a server on
             * localhost:1337. 1337 is the default Jarvis port.
             *
             * If you want to connect to a Jarvis server on a different host or
             * port, you can specify them like so:
             *
             *     Jarvis j = new Jarvis("host.example.com", 5656);
             *
             * If there is no Jarvis server running on the specified host and port,
             * a JarvisException will be raised.
             */
            Jarvis j = new Jarvis();

            /*
             * If you want to dive right in, you can call the start method to start
             * music playing on the server.
             */
            j.start();

            /*
             * And if you want to stop the music you can issue the stop command.
             */
            j.stop();

            /*
             * If you don't like the default note generator that is being used, you
             * can wrap the Jarvis server in a new note generator.
             *
             * All note generators take a Jarvis object as a parameter and will
             * instantly load up the new generator when they are instantiated.
             * Because of this, it is recommended that music is not playing when you
             * load a new generator because the generators won't switch until the
             * current one has been stopped.
             */
            Scale s = new Scale(j);

            /*
             * All note generators can run methods that belong to the Jarvis object.
             * The AbstractGenerator class automatically delegates calls with the
             * same name as Jarvis object calls to the internal Jarvis object.
             */
            s.start();

            /*
             * Volume and tempo can be set on Jarvis servers that effects all
             * generators globally.
             *
             * Volume should be between 1 and 100. Tempo can be between 1 and any
             * number you want. Be careful with super high numbers, though, you
             * might get unexpected results.
             *
             * These values can be set during play back, there is no need to
             * call stop and start to set them.
             */
            s.setVolume(50);
            s.setTempo(120);

            /*
             * It is also possible to get these values if you need to.
             */
            s.getVolume();
            s.getTempo();

            /*
             * When you are finished with your connection, be sure to make a
             * call to the close method. Similar to files, the Jarvis server
             * needs to know when clients disconnect so it can clean up
             * gracefully.
             *
             * When you have closed a Jarvis generator, it is almost guaranteed
             * that all of its methods will throw exceptions. Be sure to nullify
             * the object afterwards too.
             */
            s.stop();
            s.close();
            s = null;

            /*
             * It is possible to have multiple client connections at the same
             * time using different generators. The results may be difficult to
             * control but it's an interesting feature that's worth mentioning.
             *
             * Also note below that we aren't passing any parameters to these
             * generators. They aren't an exception to the rule, all generators
             * will automatically create a new default Jarvis object if you
             * don't pass one in. Alternately, you can pass in a host name and a
             * port to create a Jarvis object with non default arguments:
             *
             *      Otomata o = new Otomata("host.example.com", 5656);
             *
             * You cannot set individual volumes and tempos for each generator.
             * Setting volume or tempo for one will affect the volume or tempo
             * of the other.
             */
            Otomata o = new Otomata();
            Random r = new Random();

            /*
             * These two generators will now be playing at the same time sending
             * notes to the same MIDI server. It won't sound very nice but it's
             * an interesting piece of functionality.
             */
            o.start();
            r.start();

            /*
             * Clean up time!
             */
            o.stop();
            r.stop();
            o.close();
            r.close();
            o = null;
            r = null;

        } catch (JarvisException je) {
            System.out.println(je.getMessage());
        } catch (IOException ioe) {
            System.out.println(ioe.getMessage());
        }
    }
}
