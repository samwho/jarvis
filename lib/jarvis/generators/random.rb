module Jarvis
  module Generators
    class Random < NoteGenerator
      def next
        note          = Note.new rand(127)
        note.duration = Note.length rand(6)

        return note
      end

      def handle_input input
        "Random does not handle input."
      end
    end
  end
end
