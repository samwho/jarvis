if RUBY_VERSION =~ /1.8/
  module Jarvis
    class MIDIator < MIDI
      def connect
        @output = ::MIDIator::Interface.new
        @output.autodetect_driver
        Jarvis.log.debug "Created new MIDIator interface."

        aconnectil = `aconnect -il`
        input = aconnectil.match(/Client-([0-9]+)/)[0]
        MIDI.aconnect input
      end

      def play note, duration = 1, velocity = 100, channel = 0
        @output.play note, duration, channel, velocity
      end

      def close
        @output.driver.close
      end
    end
  end
end
