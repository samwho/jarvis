require 'socket'

shared_context 'server' do
  @@jarvis_host = 'localhost'
  @@jarvis_port = 1337

  # Starts up the external jarvis process and waits for it to boot. Then it
  # initiates a connection to the jarvis process under the @@socket variable.
  #
  # Commands can be sent to this jarvis instance with the send_command method.
  def start_jarvis
    @@jarvis_pid = fork do
      exec "#{Jarvis::ROOTDIR}/bin/jarvis"
    end

    sleep(1)
    @@socket = TCPSocket.new @@jarvis_host, @@jarvis_port
  end

  # Sends a command to the jarvis server that's running and returns the string
  # response from the server.
  def send_command command
    @@socket.print command
    @@last_response = @@socket.recv 4096
  end

  # Refers to the response from the last command sent to jarvis.
  def last_response
    @@last_response
  end

  # Stops the external jarvis process and closes the socket connection to it.
  def stop_jarvis
    if @@jarvis_pid
      @@socket.close if @@socket
      Process.kill('SIGINT', @@jarvis_pid)
      Process.wait(@@jarvis_pid)
      @@jarvis_pid = nil
    end
  end


  # RSpec hook to start jarvis before every test case in this context.
  before :each do
    @last_response = nil
    start_jarvis
  end

  # RSpec hook to stop jarvis after every test case in this context.
  after :each do
    stop_jarvis
  end
end
