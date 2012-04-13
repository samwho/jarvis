require File.dirname(__FILE__) + '/spec_helper.rb'

Jarvis::Generators::NoteGenerator.stdout = File.open('/dev/null', 'w')

# Loop through all of the registered generators and perform some generic tests,
# such as assert they return note objects and implement all of the methods that
# they should implement.

Jarvis::Generators::NoteGenerator.generators.each do |generator|
  describe generator do
    # Get an instance of the note generator
    generator = Jarvis::Generators.const_get(generator).new

    it "should always return Jarvis::Note objects" do
      32.times do
        generator.next.should be_a Jarvis::Note
      end
    end

    it "should be of type NoteGenerator" do
      generator.should be_a Jarvis::Generators::NoteGenerator
    end
  end
end
