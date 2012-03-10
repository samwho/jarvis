require 'logger'

module Jarvis
  def self.log
    @@log ||= Logger.new(Jarvis.options[:logfile])
  end
end
