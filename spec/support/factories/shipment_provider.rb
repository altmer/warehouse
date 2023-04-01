FactoryBot.define do
  factory :shipment_provider do
    name { %w[DHL Hermes UPS DPD GLS].sample }
  end
end
