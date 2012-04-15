module Jarvis::Generators
  class Scale < NoteGenerator
    attr_accessor :speed, :octave

    def initialize
      @notes   = Jarvis::Scale.c_major
      @pointer = 0
      @speed   = 1
      @octave  = 2
    end

    def next
      note          = Jarvis::Note.new @notes[@pointer]
      note.duration = Jarvis::Note.length @speed
      note.notes    = note.notes + 12 * octave
      @pointer      = (@pointer + 1).modulo(@notes.size)

      return note
    end

    server_command "is" do |server|
      server.generator.speed += 1
      server.send_data "Speed increased."
    end

    server_command "ds" do |server|
      server.generator.speed -= 1
      server.send_data "Speed decreased."
    end

    server_command "io" do |server|
      server.generator.octave += 1
      server.send_data "Octave increased."
    end

    server_command "do" do |server|
      server.generator.octave -= 1
      server.send_data "Octave decreased."
    end
  end
end
