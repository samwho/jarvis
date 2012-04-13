require File.dirname(__FILE__) + '/../lib/jarvis.rb'

# Include support files
Dir[File.dirname(__FILE__) + '/support/*.rb'].each { |file| require file }

# We don't want to hear what the generators have to say unless we explicitly
# state otherwise.
Jarvis::Generators::NoteGenerator.stdout = File.open('/dev/null', 'w')

# Because we aren't running the server inside event machine, we need to override
# the send_data method and keep track of the data that has been sent in the
# current request.
class Jarvis::MusicServer
  def sent_data
    @sent_data ||= []
  end

  def send_data data
    sent_data << data.to_s
  end
end
