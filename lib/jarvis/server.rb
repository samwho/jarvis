require 'optparse'

# Define the server module that will be used by EventMachine
module Jarvis
  class MusicServer < EM::Connection
    attr_accessor :generator

    def initialize *args
      super

      # Declare a default generator.
      @generator = Generators::MarkhovChains.new
      @thread = nil
    end

    # Called whenever a client disconnects.
    def unbind
      Jarvis.log.info "Client disconnected."
    end

    # This method will be called in the event of a server shutdown.
    def kill_server
      kill_generator_thread
      Jarvis.log.info "Server shutting down..."
      EventMachine.stop_event_loop
    end

    # This method is called by EventMachine every time a new client connects to
    # the server.
    def post_init
      Jarvis.log.info "Received new connection."
    end

    # An EventMachine method that receives data from a connected client.
    def receive_data data
      Jarvis.log.debug "Data received from client: #{data}"

      case data
      when "stop"
        kill_generator_thread
        send_data "Stopped successfully."
      when "start"
        start_new_generator_thread
        send_data "Started successfully."
      when "generators"
        send_data Jarvis::Generators::NoteGenerator.generators.join("\n")
      when /^load/
        # This line loads a class based on the second word given in the load
        # command.
        class_name = data.split(' ')[1]

        begin
          from = @generator.class.name
          @generator = Jarvis::Generators.const_get(class_name).new
          to = @generator.class.name
          send_data "Loaded generator #{class_name}"
          Jarvis.log.info "Switched from generator #{from} to generator #{to}"
        rescue Exception => e
          message = "Could not load class #{class_name}: #{e}"
          Jarvis.log.error message
          send_data message
        end
      when "kill_server"
        kill_server
      else
        gen_return = @generator.handle_input(data)
        if gen_return.nil?
          send_data "Command '#{data}' not recognised."
        else
          send_data gen_return
        end
      end
    end

    # Instantiates a new thread and a new connection to the MIDI driver. This
    # method will first call kill_generator_thead to ensure that there is no
    # existing thread with an existing connection to the MIDI driver.
    def start_new_generator_thread generator = @generator
      Jarvis.log.debug "Starting a new generator thread."

      # Ensure there is no running generator thread
      kill_generator_thread

      # Initiate the MIDI interface
      @midi_output = UniMIDI::Output.first

      # Connect the MIDI input to the MIDI output.
      fork do
        # Run the two aconnect calls to find input and output devices
        aconnectil = `aconnect -il`
        aconnectol = `aconnect -ol`

        # The input is easy, it will be the first virtual midi device.
        input = aconnectil.match(/(Virtual Raw MIDI [0-9]-[0-9])/)[0]

        # Output is a little more tricky. It will depend on the synth server.
        # The following code tries to search for common MIDI synths.
        output = nil
        if aconnectol =~ /TiMidity/
          output = 'TiMidity'
        elsif aconnectol =~ /FLUID Synth/
          output = "\"#{aconnectol.match(/(FLUID Synth \([0-9]+\))/)[0]}\""
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

      @thread = Thread.new(generator, @midi_output) do |generator, output|
        begin
          loop do
            # Get the next batch of notes from the generator.
            note = generator.next
            # Ensure that the notes are an array. Sometimes a generator will
            # just return an integer value.
            if note.notes.is_a?(Array)
              notes = note.notes
            else
              notes = [note.notes]
            end

            # Note on for each note in the array.
            notes.each do |note|
              output.puts 0x90, note, 100
            end

            # Sleep to ensure duration.
            sleep(note.duration)

            # Note off for each note in the array.
            notes.each do |note|
              output.puts 0x80, note, 100
            end
          end
        rescue Exception => e
          Jarvis.log.error "Generator thread died: #{e}"
          Jarvis.log.debug "Generator thread backtrace: #{e.backtrace.join("\n")}"
        end
      end
    end

    # Kills the @thread and closes the connection to the MIDI driver, in that
    # order.
    def kill_generator_thread
      unless @thread.nil? or !@thread.alive?
        Jarvis.log.debug "Killing existing generator thread."
        @thread.kill
        @midi_output.close
        @midi_output = nil
      else
        Jarvis.log.debug "kill_generator_thread called but generator thread is already dead."
      end
    end
  end
end
