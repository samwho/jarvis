module Jarvis
  class MIDI
    def initialize
      connect
    end

    def connect
      raise "Connect method needs implementing by subclass."
    end

    def play_note note
      if note.is_a? Jarvis::Note
        play note.notes, note.duration, note.velocity, note.channel
      else
        raise "Invalid argument type. Expected #{Jarvis::Note} got #{note.class}"
      end
    end

    def play note, duration = 1, velocity = 100, channel = 0
      raise "Play method needs implementing by subclass."
    end

    def close
      raise "Close method needs implementing by subclass."
    end

    def self.aconnect input
      # Connect the MIDI input to the MIDI output.
      fork do
        # Run the two aconnect calls to find input and output devices
        aconnectol = `aconnect -ol`

        # Output is little tricky. It will depend on the synth server.
        # The following code tries to search for common MIDI synths.
        output = nil
        if aconnectol =~ /TiMidity/
          output = 'TiMidity'
        elsif aconnectol =~ /FLUID Synth/
          output = "#{aconnectol.match(/(FLUID Synth \([0-9]+\))/)[0]}"
        end

        # Perform the actual connection.
        result = `aconnect "#{input}":0 "#{output}":0 2>&1`

        # General logging of outcomes.
        Jarvis.log.debug "Running aconnect: aconnect \"#{input}\":0 \"#{output}\":0 2>&1"
        if result.length != 0
          # aconnect's error message will contain the word "subscribed" when a
          # connection already exists between the given input and output. No
          # need to log this as an error.
          if result.match /subscribed/
            Jarvis.log.debug "Virtual input already linked to MIDI output."
          else
            Jarvis.log.error "Aconnect failed: #{result.strip}"
            Jarvis.log.error "You might not have a software synth, e.g. Timidity, running."
          end
        end
      end

      # Wait for the above fork to finish
      Process.wait
    end
  end
end
