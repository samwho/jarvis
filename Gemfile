source :rubygems

if RUBY_VERSION =~ /1.9/
  gem 'unimidi'
  gem 'alsa-rawmidi' # required for unimidi
  gem 'midi-jruby'   # required for unimidi
  gem 'midi-winmm'   # required for unimidi
else
  gem 'midiator'
end

gem 'eventmachine'
gem 'colored'
gem 'json'
gem 'ruby_cowsay'

group :development do
  gem 'pry'
end

group :testing do
  gem 'rspec'
  gem 'rake'
  gem 'ruby-ogginfo'
end
