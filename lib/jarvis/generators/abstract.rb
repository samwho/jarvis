class NoteGenerator
  def self.generators
    @@generators ||= []
  end

  def next
    raise "The 'next' method has not been implemented yet."
  end

  def handle_input
    raise "The 'handle_input' method has not been implemented yet."
  end

  def self.inherited subclass
    self.generators << subclass
  end
end
