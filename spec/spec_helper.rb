require File.dirname(__FILE__) + '/../lib/jarvis.rb'

# Include support files
Dir[File.dirname(__FILE__) + '/support/*.rb'].each { |file| require file }

# We don't want to hear what the generators have to say unless we explicitly
# state otherwise.
Jarvis::Generators::NoteGenerator.stdout = File.open('/dev/null', 'w')
