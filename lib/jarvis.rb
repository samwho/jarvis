require 'rubygems'
require 'eventmachine'

if RUBY_VERSION =~ /1.9/
  require 'unimidi'
else
  require 'midiator'
end

require File.dirname(__FILE__) + '/jarvis/notes.rb'
require File.dirname(__FILE__) + '/jarvis/generators/abstract.rb'

Dir[File.dirname(__FILE__) + '/jarvis/generators/*.rb'].each do |file|
  require file
end

Dir[File.dirname(__FILE__) + '/jarvis/**/*.rb'].each do |file|
  require file
end

