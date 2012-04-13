import unittest
import subprocess
import time
from jarvis.core import Jarvis

class ServerHelper(unittest.TestCase):
    DEVNULL = open('/dev/null', 'w')

    def setUp(self):
        self.process = subprocess.Popen(["jarvis", "--testing"],
                stdout=self.DEVNULL, stderr=self.DEVNULL)
        # Sleep for a second to let the server boot up. Quick and dirty but I
        # can't think of a better way of doing it.
        time.sleep(1)
        self.jarvis  = Jarvis()

    def tearDown(self):
        self.jarvis.kill_server()
        self.jarvis  = None
        self.process = None

