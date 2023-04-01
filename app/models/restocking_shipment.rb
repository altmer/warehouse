# frozen_string_literal: true

class RestockingShipment < ApplicationRecord
  belongs_to :shipment_provider
  belongs_to :merchant

  has_many :restocking_shipment_items
end
