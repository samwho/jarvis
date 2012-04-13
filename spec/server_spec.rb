require File.dirname(__FILE__) + '/spec_helper.rb'

describe Jarvis::MusicServer do
  # Tell RSpec that we're in the server context. This will give us access to an
  # instance of MusicServer in the @jarvis instance variable and access to some
  # specific helper methods.
  include_context 'server'

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
