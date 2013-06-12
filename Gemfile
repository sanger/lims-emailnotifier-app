source "http://rubygems.org"

# Specify your gem's dependencies in lims-emailnotifier-app.gemspec
gemspec

gem "mustache", "~> 0.99.4", :git => 'https://github.com/defunkt/mustache.git'
gem 'lims-busclient', '~>0.2', :git => 'https://github.com/sanger/lims-busclient.git' , :branch => 'master'

group :debugger do
  gem 'debugger', :platforms => :mri
  gem 'debugger-completion', :platforms => :mri
  gem 'shotgun', :platforms => :mri
end

group :pry do
  gem 'debugger-pry', :require => 'debugger/pry', :platforms => :mri
  gem 'pry', :platforms => :mri
end

group :deployment do
  gem "psd_logger", :git => "http://github.com/sanger/psd_logger.git"
end
