require 'lims-busclient'
require 'net/smtp'
require 'mustache'
require 'json'

require 'lims-emailnotifier-app/order_requester'

module Lims
  module EmailNotifierApp
    # This class is listening on the message queue.
    # If there is an order payload arrives to the queue, then we
    # processes it and sending an e-mail with the order details.
    class Emailer
      include Lims::BusClient::Consumer

      attribute :queue_name, String, :required => true, :writer => :private

      ORDER_PAYLOAD = "order"

      # @param [Hash] amqp_settings
      # @param [Hash] email_opts
      # @param [Hash] api_settings
      def initialize(amqp_settings, email_opts, api_settings)
        @queue_name = amqp_settings.delete("queue_name")
        @email_opts = email_opts
        @api_settings = api_settings
        consumer_setup(amqp_settings)
        set_queue
      end

      private

      # Add the listener to the queue
      # If there is a message with order payload,
      # then it is processing the message and send an e-mail with its data
      def set_queue
        self.add_queue(queue_name) do |metadata, payload|
          payload_hash = JSON.parse(payload)
          if payload_hash.keys.first == ORDER_PAYLOAD
            processing_message(metadata, payload_hash)
          end
          metadata.ack
        end
      end

      # Communicates with the lims-laboratory server and fetches the details
      # from the created order items
      def processing_message(metadata, payload)
        order_details = ""
        order_uuid = payload[ORDER_PAYLOAD].fetch("uuid")
        order_details = order_details(order_uuid)
        unless order_details.empty?
          @email_opts["order_details"] = order_details
          send_email
        end
      end

      # Requests the order from the server and gets the order details from it
      def order_details(order_uuid)
        order_requester = OrderRequester.new(@api_settings["url"], order_uuid)
        order_requester.order_details_by_order_uuid
      end

      # Processes the e-mail template and sends it as an e-mail 
      def send_email
        email_template = File.open(File.join('email_template', 'email_body_template.txt')) { |f| f.read }
        message = Mustache.render(email_template, @email_opts)

        Net::SMTP.start(@email_opts["server"]) do |smtp|
          smtp.send_message(message, @email_opts["from"], @email_opts["to"])
        end
      end

    end
  end
end
