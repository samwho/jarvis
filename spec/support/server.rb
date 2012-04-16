require 'socket'

shared_context 'server' do
  @@jarvis_host = 'localhost'
  @@jarvis_port = 1337

  def start_jarvis
    @@jarvis_pid = fork do
      $stdout = File.open('/dev/null', 'w')
      exec "#{Jarvis::ROOTDIR}/bin/jarvis"
    end

    sleep(1)
    @@socket = TCPSocket.new @@jarvis_host, @@jarvis_port
  end

  def send_command command
    @@socket.print command
    @@last_response = @@socket.recv 4096
  end

  def last_response
    @@last_response
  end

  def stop_jarvis
    if @@jarvis_pid
      @@socket.close if @@socket
      Process.kill('SIGINT', @@jarvis_pid)
      Process.wait(@@jarvis_pid)
      @@jarvis_pid = nil
    end
  end

  before :each do
    start_jarvis
  end

  after :each do
    stop_jarvis
  end
end
