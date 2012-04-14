Gem::Specification.new do |s|
  s.name = %q{jarvis}
  s.version = "0.1.4"
  s.date = %q{2012-04-14}
  s.authors = ["Sam Rose"]
  s.email = %q{samwho@lbak.co.uk}
  s.summary = %q{A Ruby generative audio framework.}
  s.homepage = %q{http://github.com/samwho/jarvis}
  s.description = %q{Jarvis offers an easy to use framework for creating note generation techniques that allow you to generate music with code.}
  s.required_ruby_version = '>= 1.8.7'
  s.license = 'MIT'
  s.bindir = 'bin'
  s.executables = ["jarvis", "jarvis-client", "learnsong"]

  s.files = []
  s.test_files = []
  Dir["lib/**/*.rb"].each { |path| s.files.push path }
  Dir["spec/**/*.rb"].each { |path| s.test_files.push path }
  Dir["data/**/*"].each { |path| s.files.push path }
  Dir["client_libs/**/*.rb"].each { |path| s.files.push path }
  s.files.push "README.md"
  s.files.push "README_virmidi.md"
  s.files.push "FAQ.md"
  s.files.push "LICENSE"
  s.files.push "Gemfile"

  s.requirements << "A MIDI software synth such as timidity or qsynth"
  s.add_dependency 'unimidi'
  s.add_dependency 'midiator'
  s.add_dependency 'eventmachine'
  s.add_dependency 'colored'
  s.add_dependency 'json'
end
