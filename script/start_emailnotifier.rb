ENV["LIMS_EMAILNOTIFIER_ENV"] = "development" unless ENV["LIMS_EMAILNOTIFIER_ENV"]

require 'yaml'
require 'lims-emailnotifier-app'
require 'logging'
require 'rubygems'
require 'ruby-debug'

module Lims
  module EmailNotifierApp
    env = ENV["LIMS_EMAILNOTIFIER_ENV"]
    amqp_settings = YAML.load_file(File.join('config','amqp.yml'))[env]
    email_opts = YAML.load_file(File.join('config','email.yml'))[env]
    api_settings = YAML.load_file(File.join('config','api_setting.yml'))[env]

    emailer = Emailer.new(amqp_settings, email_opts, api_settings)
    emailer.set_logger(Logging::LOGGER)

    Logging::LOGGER.info("Email Notifier has started")
    emailer.start
    Logging::LOGGER.info("Email Notifier has stopped")
  end
end
