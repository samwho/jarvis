module Jarvis
  def self.options
    @@options ||= Hash.new(nil)
  end

  def self.options= new_options
    @@options = new_options
  end

  def self.option_defaults
    {
      :testing => false,
      :logfile => STDOUT,
      :ip      => '127.0.0.1',
      :port    => 1337,
      :volume  => 100,
      :tempo   => 80
    }
  end
end
