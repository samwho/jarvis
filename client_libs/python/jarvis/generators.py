from jarvis.core import Jarvis

class Otomata(Jarvis):
    # Declare some constants for use with the poke method.
    UP = 1
    DOWN = 2
    LEFT = 4
    RIGHT = 8
    NONE = 0

    def poke(self, x, y):
        '''Pokes a square on the Otomata grid, changing its state. If the
        current state is NONE, the new state is UP. From there, UP goes to
        RIGHT, RIGHT goes to DOWN, DOWN goes to LEFT and LEFT goes to NONE.'''
        response = self.send_message("poke " + str(x) + " " + str(y))
        if response.endswith("up."):
            return self.UP
        elif response.endswith("down."):
            return self.DOWN
        elif response.endswith("left."):
            return self.LEFT
        elif response.endswith("right."):
            return self.RIGHT
        else:
            return self.NONE

class Scale(Jarvis):
    pass

class Random(Jarvis):
    pass

class MarkhovChains(Jarvis):
    pass

class CellularAutonoma(Jarvis):
    pass
