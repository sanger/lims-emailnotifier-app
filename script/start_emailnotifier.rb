require 'yaml'
require 'lims-emailnotifier-app'
require 'logging'
require 'rubygems'
require 'lims-exception-notifier-app/exception_notifier'

module Lims
  module EmailNotifierApp
    env = ENV["LIMS_EMAILNOTIFIER_APP_ENV"] or raise "LIMS_EMAILNOTIFIER_APP_ENV is not set in the environment"

    amqp_settings = YAML.load_file(File.join('config','amqp.yml'))[env]
    email_opts = YAML.load_file(File.join('config','email.yml'))[env]
    api_settings = YAML.load_file(File.join('config','api_setting.yml'))[env]

    notifier = Lims::ExceptionNotifierApp::ExceptionNotifier.new

    begin
      emailer = Emailer.new(amqp_settings, email_opts, api_settings)
      emailer.set_logger(Logging::LOGGER)

      Logging::LOGGER.info("Email Notifier has started")

      notifier.notify do
        emailer.start
      end
    rescue StandardError, LoadError, SyntaxError => e
      # log the caught exception
      notifier.send_notification_email(e)
    end

    Logging::LOGGER.info("Email Notifier has stopped")
  end
end
