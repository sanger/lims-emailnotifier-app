require 'rake'
require 'rake/testtask'

task :default => [:test]

task :default => [:test]
Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_spec.rb'
end

namespace :dev do
  task :setup_env do
    ENV["LIMS_EMAILNOTIFIER_ENV"] = "development"
  end

  task :run => :setup_env do
    sh "bundle exec ruby script/start_emailnotifier.rb"
  end
end

