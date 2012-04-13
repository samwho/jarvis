shared_context 'server' do
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
