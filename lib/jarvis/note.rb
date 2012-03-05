class Note
  include MIDIator::Notes
  attr_accessor :note, :duration

  def initialize note = C2, duration = 1
    @note     = note
    @duration = duration
  end

  def self.length note_length
    1.0/2 ** note_length
  end
end
