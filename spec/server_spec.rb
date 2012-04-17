describe Jarvis::MusicServer do
  # Tell RSpec that we're in the server context. This will give us access to an
  # instance of MusicServer in the @jarvis instance variable and access to some
  # specific helper methods.
  include_context 'test_server'

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

# This following testing suite fires up two external processes for each test.
# This is an inherently heavy and time consuming process so there are not many
# specs in it.
#
# The idea here is to test that all of the interprocess communication works. The
# timidity process is told to
describe "External Server Connection" do
  include_context 'timidity'
  include_context 'server'

  it 'should communicate with timidity' do
    send_command 'start'

    stop_jarvis
    stop_timidity

    test_ogg.should_not be_nil
    # test_ogg.length.should be > 0
  end

  Jarvis::Generators::NoteGenerator.generators.each do |generator|
    it "#{generator} should communicate with timidity" do
      send_command "load #{generator}"
      send_command 'start'
      send_command 'stop'

      stop_jarvis
      stop_timidity

      test_ogg.should_not be_nil
      # test_ogg.length.should be > 0
    end
  end
end
