class Random < NoteGenerator
  include ::MIDIator::Notes

  def next
    note          = Note.new rand(127)
    note.duration = Note.length rand(6)

    return note
  end

  def handle_input input
    "Random does not handle input."
  end
end
