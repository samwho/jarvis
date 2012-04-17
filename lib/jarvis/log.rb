module Jarvis
  # The main jarvis Logger instance.
  def self.log
    @@log ||= self.default_logger
  end

  # Setter method for the Jarvis.log member.
  def self.log= new_log
    @@log = new_log
  end

  # The default jarvis logger instance. This method exists simply to create the
  # Jarvis logger with the custom logging formatting an colouring. It has no
  # state. A new instance is created every time you call this method. Use the
  # Jarvis.log method to actually log things.
  def self.default_logger
    logger = Logger.new(Jarvis.options[:logfile])

    logger.formatter = proc do |severity, datetime, progname, msg|
      result = "[#{severity.ljust(5)} #{datetime}]: #{msg}\n"

      # Only set the colour if the logger is going to stdout. We don't want
      # colour information in log files.
      if Jarvis.options[:logfile] == STDOUT
        case severity
        when "DEBUG"
          result.blue
        when "WARN"
          result.yellow
        when "ERROR"
          result.red
        else
          result.white
        end
      else
        result
      end
    end

    logger.level = Jarvis.options[:loglevel]

    return logger
  end

  # Reloads the default logger. Use this if you have changed options in the
  # options hash that affect the logger directly.
  def self.reload_log
    Jarvis.log = Jarvis.default_logger
  end
end
