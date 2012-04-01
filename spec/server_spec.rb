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

    @jarvis = Jarvis::MusicServer.new nil
  end

  after :each do
    @jarvis.unbind
    @jarvis = nil
  end

  it 'responds to start' do
    response = @jarvis.receive_data "start"
    response.should include("successfully")
  end

  it 'responds to stop' do
    response = @jarvis.receive_data "start"
    response = @jarvis.receive_data "stop"
    response.should include("successfully")
  end

  it 'responds to volume commands' do
    @jarvis.receive_data("volume").should == "100"
    @jarvis.receive_data("volume 80").should == "80"
    @jarvis.receive_data("volume up").should == "85"
    @jarvis.receive_data("volume down").should == "80"
  end

  it 'responds to tempo commands' do
    @jarvis.receive_data("tempo").should == "80"
    @jarvis.receive_data("tempo 60").should == "60"
    @jarvis.receive_data("tempo up").should == "65"
    @jarvis.receive_data("tempo down").should == "60"
  end

end
