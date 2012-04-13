module Jarvis
  module Generators
    class Random < NoteGenerator
      def next
        note          = Note.new rand(127)
        note.duration = Note.length rand(6)

        return note
      end
    end
  end
end
