module Jarvis
  class Note
    include Notes
    attr_accessor :notes, :duration

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

    # Note length constants for readability
    WHOLE        = Note.length 0
    HALF         = Note.length 1
    QUARTER      = Note.length 2
    EIGHTH       = Note.length 3
    SIXTEENTH    = Note.length 4
    THIRTYSECOND = Note.length 5

    def initialize notes = C2, duration = QUARTER
      @notes    = notes
      @duration = duration
    end
  end
end
