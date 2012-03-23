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

    # Placeholder method. This should be overridden by extending classes. The
    # default behaviour is to raise an exception.
    def handle_input
      raise "The 'handle_input' method has not been implemented yet."
    end

    def self.inherited subclass
      # Split the class name on the module delimiter and only return the last
      # item, i.e. the actual class name of the generator.
      self.generators << subclass.name.split('::').last
    end
  end
end
