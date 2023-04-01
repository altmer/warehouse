module RestockingShipments
  class CreateRestockingShipment
    include Callable

    class ValidationError < StandardError; end

    def initialize(merchant, payload)
      @merchant = merchant
      @payload = payload.with_indifferent_access
    end

    def call
      validate_payload!

      ActiveRecord::Base.transaction do
        shipment = create_shipment
        shipment.restocking_shipment_items = create_items(shipment)

        shipment
      end
    end

    private

    attr_reader :merchant, :payload

    def error_message(validation)
      "Validation failed: #{validation.errors(full: true).to_a.join('; ')}"
    end

    def validate_payload!
      contract_validation = CreateRestockingShipmentRequestContract.new.call(payload)
      raise ValidationError, error_message(contract_validation) unless contract_validation.success?
    end

    def create_shipment
      RestockingShipment.create!(
        merchant_id: merchant.id,
        shipment_provider_id: payload.dig('shipper', 'shipment_provider_id'),
        shipping_cost: payload.fetch('shipping_cost'),
        estimated_arrival_date: payload.fetch('estimated_arrival_date', nil),
        tracking_code: payload.fetch('tracking_code', nil)
      )
    end

    def create_items(shipment)
      payload.fetch('skus').map do |sku|
        create_item(sku, shipment)
      end
    end

    def create_item(sku, shipment)
      RestockingShipmentItem.create!(
        restocking_shipment_id: shipment.id,
        sku_id: sku.fetch('id'),
        quantity: sku.fetch('quantity')
      )
    end
  end
end
