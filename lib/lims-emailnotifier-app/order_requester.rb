require 'lims-emailnotifier-app/helper/request_api'

module Lims::EmailNotifierApp
  class OrderRequester
    include Virtus
    include Aequitas
    include Helper::API

    # @param [String] url of the server to send the request
    # @param [String] uuid of the order to query
    def initialize(url, uuid)
      initialize_api(url)
      @uuid = uuid
    end

    # Gets the order details by order_uuid
    # @return [Array<Hash>] the array of order item's detail
    def order_details_by_order_uuid
      begin
        order_items_data = order_by_uuid
      rescue RestClient::ResourceNotFound => e
        # TODO
      end
      order_items_data
    end

    private

    # Gets the order from server and returns the order item's data
    def order_by_uuid
      order_items = []
      order = get_by_uuid(@uuid)
      item_uuids = gather_item_uuids_from_order(order)
      item_uuids.each do |item_uuid|
        order_item = {}
        order_item["uuid"] = item_uuid
        order_item_by_uuid(item_uuid, order_item)
        order_items << order_item
      end
      order_items
    end

    # Fetches the order item's uuid(s) from the order JSON
    # @return [Array] the array of order item's uuid
    def gather_item_uuids_from_order(order)
      item_uuids = []
      items = order["order"]["items"]
      items.each do |role, role_items|
        role_items.each do |item|
          item_uuids << item.fetch("uuid")
        end
      end
      item_uuids.flatten.uniq
    end

    # Gets a specific order item by its uuid
    def order_item_by_uuid(uuid, order_item)
      item = get_by_uuid(uuid)
      order_item["role"] = item.keys.first
      barcodes_from_order_item(item[item.keys.first]["labels"], order_item)
    end

    # Gets the barcode information from the asset's JSON
    def barcodes_from_order_item(labels, order_item)
      labellable_uuid = labels.fetch("uuid")
      labellable = get_by_uuid(labellable_uuid)
      labellable[labellable.keys.first]["labels"].values.each do |value|
        order_item[value['type']] = value['value']
      end
    end

  end
end
