require 'optparse'

# Define the server module that will be used by EventMachine
module Jarvis
  class MusicServer < EM::Connection
    attr_accessor :generator, :thread, :last_client_command

    def initialize *args
      super

      # Declare a default generator.
      @generator = Generators::MarkovChains.new
      @last_client_command = []
      @thread = nil

      # Load the default jarvisrc file if it exists.
      if File.exists?(File.expand_path(Jarvis.options[:jarvisrc]))
        self.class.load_jarvis_rc self
      else
        Jarvis.log.warn "Default jarvisrc file does not exist."
      end
    end

    # Loads the jarvisrc file specified by the path located in
    # Jarvis.options[:jarvisrc]. Reads the line in line by line and feeds those
    # lines into the receive_data method so it looks like they've come from the
    # client.
    #
    # Ignores comments (lines starting with #) and empty lines. Returns true if
    # the source completed successfully and false otherwise.
    def self.load_jarvis_rc server, jarvisrc = Jarvis.options[:jarvisrc]
      Jarvis.log.debug "Sourcing #{jarvisrc}..."

      begin
        File.open(jarvisrc, 'r') do |file|
          server.receive_data file.read
        end
        true
      rescue Exception => e
        Jarvis.log.error "Failed to source #{jarvisrc}: #{e.to_s}"
        puts e.to_s
        false
      end
    end

    # Helper method for registering server commands.
    def self.server_command name, &block
      Jarvis::Command.register name, &block
    end

    server_command "source" do |server, args|
      file_to_source = File.expand_path(args[1])

      if load_jarvis_rc(server, file_to_source)
        server.send_data "#{file_to_source} sourced successfully."
      else
        server.send_error "Failed to source #{file_to_source}. Check server " +
          "for details."
      end
    end

    server_command "loglevel" do |server, args|
      # Get rid of the first argument, it will be the command name. We don't
      # need it.
      args.shift

      new_loglevel = args.shift

      # If there _is_ a new log level to be set (the user sent a parameter
      # with the command) we get the new constant and set the new level then
      # reload the log.
      if new_loglevel
        begin
          Jarvis.options[:loglevel] = Logger.const_get(new_loglevel)
          Jarvis.reload_log
          server.send_data "Log level set successfully to #{new_loglevel}."
        rescue Exception => e
          server.send_error "Log level could not be set: #{e.to_s}."
        end
      else
        # If no argument was sent with the command, i.e. it was just
        # "loglevel", we return the current Jarvis logging level.
        case Jarvis.log.level
        when Logger::DEBUG
          server.send_data 'DEBUG'
        when Logger::INFO
          server.send_data 'INFO'
        when Logger::WARN
          server.send_data 'WARN'
        when Logger::ERROR
          server.send_data 'ERROR'
        when Logger::FATAL
          server.send_data 'FATAL'
        when Logger::UNKNOWN
          server.send_data 'UNKNOWN'
        end
      end
    end

    server_command "volume" do |server, args|
      # Modify the global volume.
      if args.length == 1
        server.send_data Jarvis.options[:volume].to_s
      else
        case args[1]
        when "up"
          server.send_data Jarvis.options[:volume] += 5
        when "down"
          server.send_data Jarvis.options[:volume] -= 5
        else
          if args[1].to_i != 0
            server.send_data Jarvis.options[:volume] = args[1].to_i
          else
            server.send_error "Bad volume request for data #{args[1]}"
          end
        end
      end
    end

    server_command "tempo" do |server, args|
      # Modify the global tempo.
      if args.length == 1
        server.send_data Jarvis.options[:tempo].to_s
      else
        case args[1]
        when "up"
          server.send_data Jarvis.options[:tempo] += 5
        when "down"
          server.send_data Jarvis.options[:tempo] -= 5
        else
          if args[1].to_i != 0
            server.send_data Jarvis.options[:tempo] = args[1].to_i
          else
            server.send_data "ERROR: Bad tempo request for data #{args[1]}"
          end
        end
      end
    end

    server_command "stop" do |server|
      # Stop the current note generator thread. Does nothing if a current note
      # generator thread is running.
      server.stop_generator_thread
      server.send_data "Stopped successfully."
    end

    server_command "start" do |server|
      # Start a new note generator thread. Will close the current thread and
      # start a new one if a thread ic currently running.
      server.start_new_generator_thread
      server.send_data "Started successfully."
    end

    server_command "generators" do |server|
      # Send a list of note generators back to the client.
      server.send_data Jarvis::Generators::NoteGenerator.generators.join("\n")
    end

    server_command "load" do |server, args|
      # This line loads a class based on the second word given in the load
      # command.
      class_name = args[1]

      begin
        from = server.generator.class.name
        server.generator = Jarvis::Generators.const_get(class_name).new
        to = server.generator.class.name
        server.send_data "Loaded generator #{class_name}"
        Jarvis.log.info "Switched from generator #{from} to generator #{to}"
      rescue Exception => e
        message = "Could not load class #{class_name}: #{e}"
        Jarvis.log.error message
        server.send_error message
      end
    end

    server_command "kill_server" do |server|
      server.kill_server
    end


    # This method will prepend the string "ERROR: " to a message and then pass
    # it to the send_data method. The point of this is that the client libraries
    # search server reponses for "ERROR: " and will throw an exception if they
    # find it. This makes sure that if you want to send an error, you just need
    # to call this method and not worry about it.
    def send_error message
      send_data "ERROR: " + message
    end

    # Called whenever a client disconnects.
    def unbind
      Jarvis.log.info "Client disconnected."
      stop_generator_thread
    end

    # This method will be called in the event of a server shutdown.
    def kill_server
      stop_generator_thread
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

      # Commands are delimited by new lines or semi colons. Split the data on
      # that and run each command sequentially.
      data.split(/\s*(?:\n|;)\s*/).each do |command|
        # Ignore commands that are just empty strings or comments.
        next if command.length == 0 or command =~ /^\s*#/
          @last_client_command = Shellwords.shellwords(command)

        begin
          Jarvis::Command.call @last_client_command.first, self,
            @last_client_command
        rescue Exception => e
          send_error e.to_s
          Jarvis.log.error "Command threw an exception: #{e}"
          Jarvis.log.debug "Command exception backtrace: #{e.backtrace.join("\n")}"

          # Break out of the command execution loop just in case a future
          # command depended on the one that failed.
          break
        end
      end
    end

    # This patch just adds a new line to the end of each bit of data sent back
    # to the client. This become a necessity when multiple called to send_data
    # are made in one "request".
    def send_data data
      data = data.to_s + "\n"
      super
    end

    # Instantiates a new thread and a new connection to the MIDI driver. This
    # method will first call stop_generator_thead to ensure that there is no
    # existing thread with an existing connection to the MIDI driver.
    def start_new_generator_thread generator = @generator
      Jarvis.log.debug "Starting a new generator thread."

      # Ensure there is no running generator thread
      stop_generator_thread


      @thread = Thread.new(generator, Jarvis::MIDI.instance) do |generator, output|
        # This following line caused a really interesting bug. If you sent the
        # stop signal fast enough, this line would actually overwrite the stop
        # value to false _after_ it had been set. Debugging this one was a
        # massive pain and it only came out during testing in the Ruby 1.9
        # series. 1.8.7 seems to handle the issue differently. Neat, huh?
        # Thread.current[:stop] = false

        begin
          loop do
            # Get the next batch of notes from the generator.
            output.play_note generator.next

            Thread.exit if Thread.current[:stop]
          end
        rescue Exception => e
          Jarvis.log.error "Generator thread died: #{e}"
          Jarvis.log.debug "Generator thread backtrace: #{e.backtrace.join("\n")}"
        end
      end
    end

    # Gracefully signals the current generator thread to stop. The generator
    # thread will check its own Thread.current[:stop] variable after each note
    # has finished. If this variable is true, the thread will exit on its own
    # accord.
    #
    # This method calls @thread.join after signalling a stop, so this method
    # blocks until the thread exits.
    def stop_generator_thread
      unless @thread.nil? or !@thread.alive?
        Jarvis.log.debug "Stopping existing generator thread."
        @thread[:stop] = true
        @thread.join
      else
        Jarvis.log.debug "stop_generator_thread called but generator thread is already dead."
      end
    end
  end
end
