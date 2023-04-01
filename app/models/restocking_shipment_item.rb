# frozen_string_literal: true

class RestockingShipmentItem < ApplicationRecord
  belongs_to :sku
  belongs_to :restocking_shipment
end
