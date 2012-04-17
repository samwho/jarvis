import socket

class JarvisError(Exception):
    def __init__(self, message):
        self.message = message
    def __str__(self):
        return self.message

class Jarvis:
    def __init__(self, host = 'localhost', port = 1337):
        '''Creates a client connection to the Jarvis server. If the server is
        now running or the connection is not accepted for any other reason, a
        JarvisError is raised.'''
        try:
            self.socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.socket.connect((host, port))

            if self.__class__.__name__ != 'Jarvis':
                self.load(self.__class__.__name__)
        except Exception as e:
            raise JarvisError(e.__str__())


    def send_message(self, message):
        '''Sends a message to the Jarvis server. If an error occurs in sending
        the message, or an error occurs on the server because the message was
        not valid, a JarvisError is raised.'''
        try:
            self.socket.send(message)
            response =  self.socket.recv(4096)
            if response.startswith("ERROR: "):
                raise JarvisError(response.strip())
            else:
                return response.strip()
        except Exception as e:
            raise JarvisError(e.__str__())

    def send_generator_message(self, message):
        '''Sends a message from this class, automatically prepending the
        generator prefix based on the class name.'''
        return self.send_message(self.__class__.__name__ + '.' + message)

    def load(self, generator):
        return self.send_message("load " + str(generator))

    def start(self):
        '''Signals the server to start playing music.'''
        return self.send_message("start")

    def stop(self):
        '''Signals the server to stop playing music.'''
        return self.send_message("stop")

    def volume(self, v = None):
        '''Sets or gets the global server volume. This method will return the
        current volume if no parameters are passed and it will return the new
        volume if a new volume parameter is passed in.'''
        if v == None:
            return int(self.send_message("volume"))
        else:
            return int(self.send_message("volume " + str(v)))

    def tempo(self, t = None):
        '''Sets or gets the global server tempo. This method will return the
        current tempo is no parameters are passed and it will return the new
        tempo if a new tempo parameter is passed in.'''
        if t == None:
            return int(self.send_message("tempo"))
        else:
            return int(self.send_message("tempo " + str(t)))

    def volume_up(self):
        '''This method will increase the volume by a small increment and return
        the new volume.'''
        return int(self.send_message("volume up"))

    def volume_down(self):
        '''This method will decrease the volume by a small increment and return
        the new volume.'''
        return int(self.send_message("volume down"))

    def tempo_up(self):
        '''This method will increase the tempo by a small increment and return
        the new tempo.'''
        return int(self.send_message("tempo up"))

    def tempo_down(self):
        '''This method will decrease the tempo by a small increment and return
        the new tempo.'''
        return int(self.send_message("tempo down"))

    def kill_server(self):
        '''This method will terminate the server process, disconnecting all
        connected clients in the process. Use with extreme caution.'''
        self.send_message("kill_server")
