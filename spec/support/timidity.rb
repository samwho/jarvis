require 'ogginfo'
require 'fileutils'

shared_context "timidity" do
  # Starts up timidity in an external process. It is told to output all sounds
  # in ogg vorbis format to a test.ogg file defined by the test_ogg_path method
  # of this context.
  def start_timidity
    @@timidity_pid = fork do
      exec "timidity -iA -Ov -o #{test_ogg_path}"
    end

    sleep(1)
  end

  # Stops the external timidity process.
  def stop_timidity
    if @@timidity_pid
      Process.kill('SIGINT', @@timidity_pid)
      Process.wait(@@timidity_pid)
      @@timidity_pid = nil
    end
  end

  # The absolute path to the test.ogg file that we are telling timidity to write
  # to.
  def test_ogg_path
    Jarvis::ROOTDIR + '/spec/data/test.ogg'
  end

  # Gets the designated test.ogg file from inside spec/data. If the ogg file is
  # empty or not there, nil will be returned. This is useful for asserting that
  # notes actually made it to the server.
  def test_ogg
    begin
      OggInfo.open(test_ogg_path)
    rescue Exception => e
      nil
    end
  end

  # Sets up an rspec hook to start the timidity server before each spec
  before :each do
    # Ensure that a test.ogg file exists.
    FileUtils.touch test_ogg_path

    start_timidity
  end

  # Sets up an rspec hook to stop the timidity process after each spec
  after :each do
    stop_timidity

    # Ensure that the test.ogg file is clean before the next test.
    FileUtils.rm test_ogg_path
    FileUtils.touch test_ogg_path
  end
end
