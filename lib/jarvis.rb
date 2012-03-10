require 'rubygems'
require 'eventmachine'
require 'midiator'

require File.dirname(__FILE__) + '/jarvis/generators/abstract.rb'

Dir[File.dirname(__FILE__) + '/jarvis/generators/*.rb'].each do |file|
  require file
end

Dir[File.dirname(__FILE__) + '/jarvis/**/*.rb'].each do |file|
  require file
end

