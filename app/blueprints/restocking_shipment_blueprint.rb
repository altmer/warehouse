# frozen_string_literal: true

class RestockingShipmentBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    fields :status

    field :sku_count do |object, _|
      object.restocking_shipment_items.count(:sku_id)
    end

    field :total_count do |object, _|
      object.restocking_shipment_items.sum(:quantity)
    end

    association :shipment_provider, blueprint: ShipmentProviderBlueprint
  end

  view :extended do
    include_view :normal

    fields :id, :shipping_cost

    association :restocking_shipment_items, blueprint: RestockingItemBlueprint
  end
end
