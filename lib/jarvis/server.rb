require 'optparse'

# Define the server module that will be used by EventMachine
module Jarvis
  class MusicServer < EM::Connection
    attr_accessor :generator

    def initialize *args
      super

      # Declare a default generator.
      @generator = ::MarkhovChains.new
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
        send_data NoteGenerator.generators.join("\n")
      when /^load/
        # This line loads a class based on the second word given in the load
        # command.
        class_name = data.split(' ')[1]

        begin
          from = @generator.class.name
          @generator = Module.const_get(class_name).new
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

      # Initiate the MIDI interface and driver.
      @midi = MIDIator::Interface.new
      @midi.autodetect_driver

      # Connect the MIDI input to the MIDI output.
      fork do
        aconnect = `aconnect -il`
        m = aconnect.match /Client-([0-9]+)/
        result = `aconnect #{m[0]}:0 TiMidity:0 2>&1`
        if result.length != 0
          Jarvis.log.error "Aconnect failed: #{result.strip}"
          Jarvis.log.error "You might not have a software synth, e.g. Timidity, running."
        end
      end

      # Wait for the above fork to finish
      Process.wait

      @thread = Thread.new(generator, @midi) do |g, m|
        begin
          loop do
            n = g.next
            m.play n.note, n.duration
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
        @midi.driver.close
      else
        Jarvis.log.debug "kill_generator_thread called but generator thread is already dead."
      end
    end
  end
end
