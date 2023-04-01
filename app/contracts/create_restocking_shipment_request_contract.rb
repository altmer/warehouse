require 'dry-validation'

class CreateRestockingShipmentRequestContract < Dry::Validation::Contract
  json do
    required(:shipping_cost).value(:float)
    optional(:estimated_arrival_date).value(:date)
    optional(:tracking_code).value(:string)
    required(:shipper).hash do
      required(:shipment_provider_id).value(:integer)
    end
    required(:skus).array(:hash) do
      required(:id).value(:integer)
      required(:quantity).value(:integer)
    end
  end

  rule(:skus) do
    key.failure('must not be empty') if value.empty?
  end

  rule(:estimated_arrival_date) do
    key.failure('must not be in the past') if value < Date.today
  end
end
