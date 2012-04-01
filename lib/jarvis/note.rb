module Jarvis
  class Note
    include Notes
    attr_accessor :notes, :duration, :velocity, :channel

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

    def initialize notes = [], duration = QUARTER, velocity = 100, channel = 0
      @notes    = notes
      @duration = duration
      @velocity = velocity
      @channel  = channel
    end

    def to_s
      "notes=#{notes.inspect} duration=#{duration} channel=#{channel} velocity=#{velocity}"
    end
  end
end
