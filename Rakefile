task :default => ["dev:run"]

namespace :dev do
  task :setup_env do
    ENV["LIMS_EMAILNOTIFIER_ENV"] = "development"
  end

  task :run => :setup_env do
    sh "bundle exec ruby script/start_emailnotifier.rb"
  end
end
