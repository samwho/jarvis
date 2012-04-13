require 'rubygems'
require 'eventmachine'
require 'optparse'
require 'colored'
require 'logger'
require 'shellwords'
require 'pry'

if RUBY_VERSION =~ /1.9/
  require 'unimidi'
else
  require 'midiator'
end

# Add library directory to load path
libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'jarvis/options'
require 'jarvis/command'
require 'jarvis/notes'
require 'jarvis/note'
require 'jarvis/scales'
require 'jarvis/log'
require 'jarvis/midi'
require 'jarvis/midi/midiator'
require 'jarvis/midi/unimidi'
require 'jarvis/server'
require 'jarvis/generators/abstract'
require 'jarvis/generators/cellular'
require 'jarvis/generators/markhov'
require 'jarvis/generators/otomata'
require 'jarvis/generators/random'
require 'jarvis/generators/scale'

# Load user external generators.
module Jarvis::Generators
  Dir[File.expand_path("~/.jarvis/generators/*.rb")].each do |file|
    require file
  end
end
