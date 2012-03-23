if RUBY_VERSION =~ /1.9/
  module Jarvis
    class UniMIDI < MIDI
      def connect
        aconnectil = `aconnect -il`
        input = aconnectil.match(/(Virtual Raw MIDI [0-9]-[0-9])/)[0]
        MIDI.aconnect input

        @output = ::UniMIDI::Output.first
      end

      def play note, duration = 1, velocity = 100, channel = 0
        if note.is_a?(Array)
          notes = note
        else
          notes = [note]
        end

        # Note on for each note in the array.
        notes.each do |note|
          @output.puts 0x90, note, velocity
        end

        # Sleep to ensure duration.
        sleep(duration)

        # Note off for each note in the array.
        notes.each do |note|
          @output.puts 0x80, note, velocity
        end
      end

      def close
        @output.close
      end
    end
  end
end
