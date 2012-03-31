import sys, os, time

root_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
sys.path.append(root_dir)

from jarvis.generators import *

o = Otomata()
m = MarkhovChains()
r = Random()
c = CellularAutonoma()
s = Scale()

print o.poke(1, 1)
print o.poke(1, 1)
print o.poke(1, 1)
print o.poke(1, 1)
print o.poke(1, 1)
