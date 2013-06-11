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

    def order_details_by_order_uuid
      order_details = ""

      begin
        order_items_data = order_by_uuid
      rescue RestClient::ResourceNotFound => e
        # TODO
      else
        order_items_data.each do |data|
          order_details += add_order_item_data(data)
        end
      end
      order_details
    end

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

    def gather_item_uuids_from_order(order)
      item_uuids = []
      items = order["order"]["items"]
      items.each do |role, role_items|
        role_items.each do |item|
          item_uuids << item.fetch("uuid")
        end
      end
      item_uuids.flatten
    end

    def order_item_by_uuid(uuid, order_item)
      item = get_by_uuid(uuid)
      order_item["role"] = item.keys.first
      barcodes_from_order_item(item[item.keys.first]["labels"], order_item)
    end

    def barcodes_from_order_item(labels, order_item)
      labellable_uuid = labels.fetch("uuid")
      labellable = get_by_uuid(labellable_uuid)
      labellable[labellable.keys.first]["labels"].values.each do |value|
        order_item[value['type']] = value['value']
      end
    end

    def add_order_item_data(item)
      item_str = ""
      item_str = "Role: " + item["role"] + ", uuid: " + item["uuid"]
      item_str += ", sanger barcode: " + item["sanger-barcode"] if item["sanger-barcode"]
      item_str += ", ean13 barcode: " + item["ean13-barcode"] if item["ean13-barcode"]
      item_str += "\n"
    end

  end
end
