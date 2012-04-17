# This shared context sets up all of the appropriate methods and monkey patches
# that are needed to create and use a MusicServer object without running it
# through EventMachine.

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

shared_context 'test_server' do
  # Helper method to send a command to the Jarvis server.
  def send_command command
    @jarvis.receive_data command
    @last_response = @jarvis.sent_data.last
  end

  # Helper method to check the value of the last command sent.
  def last_response
    @last_response
  end

  before :each do
    # Set option defaults and override testing to true
    Jarvis.options = Jarvis.option_defaults
    Jarvis.options[:logfile] = '/dev/null'
    Jarvis.options[:testing] = true
    Jarvis.log = Jarvis.default_logger

    # Reset the commands array. This stops duplicate command errors.
    Jarvis::Command.reset

    @jarvis = Jarvis::MusicServer.new nil
    @last_response = nil
  end

  after :each do
    @jarvis.unbind
    @jarvis = nil
  end

end
