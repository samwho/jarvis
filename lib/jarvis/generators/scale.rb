class Scale < NoteGenerator
  include ::MIDIator::Notes
  attr_accessor :speed, :octave

  def initialize
    @notes   = [Note.new(C0), Note.new(D0), Note.new(E0), Note.new(F0),
                Note.new(G0), Note.new(A1), Note.new(B1), Note.new(C1)]
    @pointer = 0
    @speed = 1
    @octave = 2
  end

  def next
    note     = @notes[@pointer].dup
    note.duration = Note.length @speed
    note.note = note.note + 12 * octave
    @pointer = (@pointer + 1).modulo(@notes.size)

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
