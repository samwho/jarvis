require 'optparse'

# Define the server module that will be used by EventMachine
class MusicServer < EM::Connection
  attr_accessor :generator

  def initialize *args
    super

    # Declare an options array for storing options from the command line.
    @options = {
      :seed => 0
    }

    # Parse command line args
    OptionParser.new do |opts|
      opts.on('-s', '--seed SEED', 'Seed for the random number generator') do |s|
        @options[:seed] = s.to_i
        srand @options[:seed]
      end
    end.parse!

    # Declare a default generator.
    @generator = ::MarkhovChains.new
    @thread = nil
  end

  # This method is called by EventMachine every time a new client connects to
  # the server.
  def post_init
    puts "Starting generator #{@generator.class}..."
    start_new_generator_thread
  end

  # An EventMachine method that receives data from a connected client.
  def receive_data data
    case data
    when "stop"
      kill_generator_thread
    when "start"
      start_new_generator_thread
    when /^load/
      # This line loads a class based on the last word given in the load
      # command.
      class_name = data.split(' ').last

      begin
        @generator = Module.const_get(class_name).new
        puts "Loaded generator #{class_name}"
      rescue Exception => e
        puts "Could not load class #{class_name}: #{e}"
      end
    else
      send_data @generator.handle_input(data)
    end
  end

  # Insteantiates a new thread and a new connection to the MIDI driver. This
  # method will first call kill_generator_thead to ensure that there is no
  # existing thread with an existing connection to the MIDI driver.
  def start_new_generator_thread generator = @generator
    # Ensure there is no running generator thread
    kill_generator_thread

    # Initiate the MIDI interface and driver.
    @midi = MIDIator::Interface.new
    @midi.autodetect_driver

    # Connect the MIDI input to the MIDI output.
    # This is going to vary from machine to machine.
    fork { `aconnect 129:0 128:0` }
    Process.wait

    @thread = Thread.new(generator, @midi) do |g, m|
      loop do
        n = g.next
        m.play n.note, n.duration
      end
    end
  end

  # Kills the @thread and closes the connection to the MIDI driver, in that
  # order.
  def kill_generator_thread
    unless @thread.nil? or !@thread.alive?
      @thread.kill
      @midi.driver.close
    end
  end
end
