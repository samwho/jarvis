require 'rubygems'
require 'eventmachine'
require 'midiator'

# Require all files in the main lib directory
Dir[File.dirname(__FILE__) + '/jarvis/generators/*.rb'].each do |file|
  require file
end

Dir[File.dirname(__FILE__) + '/jarvis/**/*.rb'].each do |file|
  require file
end

