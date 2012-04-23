from test import helpers
from jarvis.core import JarvisError

class ServerTest(helpers.ServerHelper):
    def test_volume(self):
        self.assertEqual(100, self.jarvis.volume())
        self.assertEqual(95, self.jarvis.volume_down())
        self.assertEqual(100, self.jarvis.volume_up())
        self.assertEqual(20, self.jarvis.volume(20))

    def test_tempo(self):
        self.assertEqual(80, self.jarvis.tempo())
        self.assertEqual(75, self.jarvis.tempo_down())
        self.assertEqual(80, self.jarvis.tempo_up())
        self.assertEqual(20, self.jarvis.tempo(20))

    def test_start(self):
        assert "successfully" in self.jarvis.start()

    def test_stop(self):
        self.jarvis.start()
        assert "successfully" in self.jarvis.stop()

    def test_load_random(self):
        assert "Loaded" in self.jarvis.load("Random")

    def test_load_otomata(self):
        assert "Loaded" in self.jarvis.load("Otomata")

    def test_load_markov(self):
        assert "Loaded" in self.jarvis.load("MarkovChains")

    def test_load_scale(self):
        assert "Loaded" in self.jarvis.load("Scale")

    def test_load_fail(self):
        with self.assertRaises(JarvisError):
            self.jarvis.load("NotAGenerator")

    def test_non_existant_command(self):
        with self.assertRaises(JarvisError):
            self.jarvis.send_message("definitelynotacommandatall")

    def test_generator_command_on_wrong_generator(self):
        with self.assertRaises(JarvisError):
            self.jarvis.load("Random")
            self.jarvis.send_message("Otomata.poke 1 1")
