class Note
  include MIDIator::Notes
  attr_accessor :note, :duration

  # Note length constants for readability
  WHOLE        = 0
  HALF         = 1
  QUARTER      = 2
  EIGHTH       = 3
  SIXTEENTH    = 4
  THIRTYSECOND = 5

  def initialize note = C2, duration = QUARTER
    @note     = note
    @duration = duration
  end

  # Gets a note length based on the following formula:
  #   1 / 2 ^ note_length
  #
  # Where note_length is the value passed into this method. There are various
  # constants on this class that help with this method, they are as follows:
  #
  # Note::WHOLE
  # Note::HALF
  # Note::QUARTER
  # Note::EIGHTH
  # Note::SIXTEENTH
  # Note::THIRTYSECOND
  def self.length note_length
    1.0/2 ** note_length
  end
end
