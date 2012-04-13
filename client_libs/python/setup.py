from distutils.core import setup
import os

setup(
    name = 'JarvisPythonLibrary',
    version = '0.1dev',
    author = 'Sam Rose',
    author_email = 'samwho@lbak.co.uk',
    packages = ['jarvis',],
    license = 'LICENSE.txt',
    long_description = open(os.path.dirname(os.path.abspath(__file__)) + '/README').read(),
)
