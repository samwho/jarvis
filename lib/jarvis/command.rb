module Jarvis::Command
  # Gets a command by its name using array access syntax. Example:
  #
  #   Jarvis::Command['start']
  def self.[] command_name
    self.list[command_name]
  end

  # A list of all of the commands. This is a hash structur of key => value pairs
  # where the key is the name of the command and the value is the block
  # associated with it.
  def self.list
    @@command ||= Hash.new(nil)
  end

  # This method will call a command or raise an exception if it does not exist.
  #
  # You should pass into here the MusicServer instance that received the command
  # and the arguments you would like to pass to the command. Preferably the
  # arguments should be in the same format as ARGV, namely a Shellwords parsed
  # array.
  def self.call name, server, args
    # This block of code here checks to see if the correct generator is loaded
    # for a specific command. For example, if someone runs Otomata.poke and the
    # Scale generator is loaded, there will be unexpected results. We don't want
    # that to happen.
    split_name = name.split('.')
    if split_name.length == 2
      klass = Jarvis::Generators.const_get(split_name.first)
      unless server.generator.is_a? klass
        raise "Incorrect generator loaded for command #{name}."
      end
    end

    if self.list.keys.include? name
      case self[name].arity
      when 1
        self[name].call server
      when 2
        self[name].call server, args
      when 3
        self[name].call server, args, server.generator
      end
    else
      raise "No command of name #{name} exists."
    end
  end

  # Register a new command. Will raise an exception if a command by the same
  # name exists.
  #
  # Example:
  #
  #   Jarvis::Command.register "start" do |server, args|
  #     server.start
  #     server.send_data "Started!"
  #   end
  def self.register name, &block
    if self.list.keys.include? name
      raise "ERROR: Command conflict: #{name} command already exists."
    else
      self.list[name] = block
    end
  end

  # Reset the command list. This is for testing purposes only.
  def self.reset
    @@command = nil
  end
end
