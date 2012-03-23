module Jarvis::Generators
  class Scale < NoteGenerator
    attr_accessor :speed, :octave

    def initialize
      @notes   = [
        Jarvis::Note.new(C0),
        Jarvis::Note.new(D0),
        Jarvis::Note.new(E0),
        Jarvis::Note.new(F0),
        Jarvis::Note.new(G0),
        Jarvis::Note.new(A1),
        Jarvis::Note.new(B1),
        Jarvis::Note.new(C1)]
      @pointer = 0
      @speed = 1
      @octave = 2
    end

    def next
      note          = @notes[@pointer].dup
      note.duration = Jarvis::Note.length @speed
      note.notes    = note.notes + 12 * octave
      @pointer      = (@pointer + 1).modulo(@notes.size)

      return note
    end

    def handle_input input
      case input
      when "is"
        @speed += 1
        return "Speed increased."
      when "ds"
        @speed -= 1
        return "Speed decreased."
      when "io"
        @octave += 1
        return "Octave increased."
      when "do"
        @octave -= 1
        return "Octave decreased."
      end
    end
  end
end
