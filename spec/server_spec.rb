require File.dirname(__FILE__) + '/spec_helper.rb'

# Because we aren't running the server inside event machine, we need to override
# the send_data method so it just returns the message to be sent rather than
# actually trying to send it anywhere.
class Jarvis::MusicServer
  def send_data data
    return data.to_s
  end
end

describe Jarvis::MusicServer do
  before :each do
    # Set option defaults and override testing to true
    Jarvis.options = Jarvis.option_defaults
    Jarvis.options[:logfile] = '/dev/null'
    Jarvis.options[:testing] = true
    Jarvis.log = Jarvis.default_logger

    @jarvis = Jarvis::MusicServer.new nil
    @last_response = nil
  end

  after :each do
    @jarvis.unbind
    @jarvis = nil
  end

  # Helper method to send a command to the Jarvis server.
  def send_command command
    @last_response = @jarvis.receive_data command
  end

  # Helper method to check the value of the last command sent.
  def last_response
    @last_response
  end

  it 'responds to start' do
    send_command "start"
    last_response.should include("successfully")
  end

  it 'responds to stop' do
    send_command "start"
    send_command "stop"
    last_response.should include("successfully")
  end

  it 'responds to volume commands' do
    send_command "volume"
    last_response.should == "100"

    send_command "volume 80"
    last_response.should == "80"

    send_command "volume up"
    last_response.should == "85"

    send_command "volume down"
    last_response.should == "80"
  end

  it 'responds to tempo commands' do
    send_command "tempo"
    last_response.should == "80"

    send_command "tempo 60"
    last_response.should == "60"

    send_command "tempo up"
    last_response.should == "65"

    send_command "tempo down"
    last_response.should == "60"
  end

  it 'handles commands that are not recognised' do
    send_command 'definitelynotgoingtoberecognised'
    last_response.should include('ERROR')
    last_response.should include('definitelynotgoingtoberecognised')
  end

  it 'handles bad load commands' do
    send_command 'load Notarealgeneratorwhatsoeverlol'
    last_response.should include('ERROR')
    last_response.should include('Notarealgeneratorwhatsoeverlol')
  end

  it 'handles bad volume requests' do
    send_command 'volume garbage'
    last_response.should include('ERROR')

    send_command 'volume 80'
    send_command 'volume moregarbage lol'
    last_response.should include('ERROR')
  end
end
