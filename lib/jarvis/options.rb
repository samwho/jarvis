module Jarvis
  # Getter for the options hash. Defaults to the option_defaults class method.
  def self.options
    @@options ||= self.option_defaults
  end

  # Setter for the options hash.
  def self.options= new_options
    @@options = new_options
  end

  # Creates a new Hash object that defaults to nil and contains the default
  # options hash, that looks like this:
  #
  # {
  #   :testing  => false,
  #   :logfile  => STDOUT,
  #   :ip       => '127.0.0.1',
  #   :port     => 1337,
  #   :volume   => 100,
  #   :tempo    => 80
  #   :jarvisrc => File.expand_path('~/.jarvisrc')
  # }
  def self.option_defaults
    defaults             = Hash.new(nil)
    defaults[:testing]   = false
    defaults[:logfile]   = STDOUT
    defaults[:loglevel]  = Logger::INFO
    defaults[:ip]        = '127.0.0.1'
    defaults[:port]      = 1337
    defaults[:volume]    = 100
    defaults[:tempo]     = 80
    defaults[:jarvisrc]  = File.expand_path('~/.jarvisrc')
    defaults[:generator] = "MarkovChains"
    return defaults
  end

  # Parses the ARGV array and resets anything that needs to be reset in the
  # process. For example, the logger needs to be reset after options have been
  # parsed.
  def self.parse_command_line_args
    # A check variable to be set if the log needs reloading.
    log_reload = false

    OptionParser.new do |opts|
      opts.on('-s', '--seed SEED', 'Seed for the random number generator') do |s|
        Jarvis.options[:seed] = s.to_i
        srand Jarvis.options[:seed]
      end

      opts.on('-l', '--log FILE', 'File to log server output to.') do |file|
        Jarvis.options[:logfile] = file
        log_reload = true
      end

      opts.on('--no-welcome') do
        Jarvis.options[:nowelcome] = true
      end

      opts.on('-d', '--debug', 'Sets debugging mode to false. Equivalent to ' +
                               'setting the loglevel to DEBUG.') do
        Jarvis.options[:debug] = true
        Jarvis.options[:loglevel] = Logger::DEBUG
        log_reload = true
      end

      opts.on('-p', '--port PORT', 'Port number of Jarvis server.') do |port|
        Jarvis.options[:port] = port.to_i
      end

      opts.on('-i', '--ip IP', 'IP address of Jarvis server.') do |ip|
        Jarvis.options[:ip] = ip
      end

      opts.on('-t', '--testing', 'Boot the server in testing mode.') do
        Jarvis.options[:testing] = true
      end

      opts.on('--loglevel LEVEL', 'The level of logging to output. ' +
              'DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN') do |level|
        begin
          Jarvis.options[:loglevel] = Logger.const_get(level)
          log_reload = true
        rescue
          Jarvis.log.error "Could not set log level. #{level} is not valid. " +
            "Must be one of the following: " +
            "DEBUG < INFO < WARN < ERROR < FATAL < UNKNOWN"
        end
      end

      opts.on('--jarvisrc PATH', 'Path to the jarvis rc file. Defaults to ' +
                                 '~/.jarvisrc') do |jarvisrc|
        Jarvis.options[:jarvisrc] = jarvisrc
      end

      opts.on('-g', '--generator GENERATOR', 'Default note generator.') do |g|
        Jarvis.options[:generator] = g
      end
    end.parse!

    # Reload the log if it is required.
    Jarvis.reload_log if log_reload
  end
end
