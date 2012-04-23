require 'rspec/core/rake_task'
CURRENT_DIR = File.dirname(__FILE__)

task :default => 'test:all'

namespace :test do
  task :all => [:core, 'libs:java', 'libs:python']

  desc "Run core tests"
  RSpec::Core::RakeTask.new(:core) do |t|
    t.rspec_opts = '-cfs'
  end

  namespace :libs do
    desc "Run Java client library tests"
    task :java do
      fork do
        exec "cd #{CURRENT_DIR}/client_libs/java; ./test.sh;"
      end
      Process.wait
      exit_code = $?.exitstatus
      exit exit_code if exit_code != 0
    end

    desc "Run Python client library tests"
    task :python do
      fork do
        exec "cd #{CURRENT_DIR}/client_libs/python; ./test.sh;"
      end
      Process.wait
      exit_code = $?.exitstatus
      exit exit_code if exit_code != 0
    end
  end
end
