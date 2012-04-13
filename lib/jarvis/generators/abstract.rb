module Jarvis::Generators
  class NoteGenerator
    # Include the Notes class. This gives generators access to nice note names
    # such as C3 and G1.
    include ::Jarvis::Notes

    # A list of note generators that have subclassed the pseudo-abstract
    # NoteGenerator class.
    def self.generators
      @@generators ||= []
    end

    # Placeholder method. This should be overridden by extending classes. The
    # default behaviour is to raise an exception.
    def next
      raise "The 'next' method has not been implemented yet."
    end

    # Define a standard output for note generators. This is primarily for
    # testing purposes. We don't really want to see all of the output of the
    # note generators in a test environment.
    def self.stdout
      @@stdout ||= STDOUT
    end

    # Sets a new stdout object for note generators. In testing, this is set to
    # /dev/null.
    def self.stdout= newstdout
      @@stdout = newstdout
    end

    # If note generators want to output to the screen, this lets them but it
    # also gives us the freedom to silence those messages in testing.
    def puts output
      self.class.stdout.puts output
    end

    # If note generators want to output to the screen, this lets them but it
    # also gives us the freedom to silence those messages in testing.
    def print output
      self.class.stdout.print output
    end

    # Helper method for defining server commands inside note generators.
    # Generators can now do the following to register a command with the server
    # at load time:
    #
    #   class TestGenerator < NoteGenerator
    #     server_command "test" do |server|
    #       server.send_data "Passed!"
    #     end
    #   end
    #
    # Now the client command "test" will return "Passed!" to the client.
    def self.server_command name, &block
      Jarvis::Command.register((self.name.split('::').last) + '.' + name, &block)
    end

    def self.inherited subclass
      # Split the class name on the module delimiter and only return the last
      # item, i.e. the actual class name of the generator.
      simple_name = subclass.name.split('::').last
      self.generators << simple_name

      Jarvis.log.info "Loaded generator #{simple_name}"
    end
  end
end
