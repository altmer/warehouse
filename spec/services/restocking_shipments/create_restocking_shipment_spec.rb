require 'rails_helper'

RSpec.describe RestockingShipments::CreateRestockingShipment do
  subject { described_class.call(merchant, payload) }

  let(:merchant) { FactoryBot.create(:merchant) }
  let(:sku) { FactoryBot.create(:sku) }
  let(:shipment_provider) { FactoryBot.create(:shipment_provider) }

  let(:estimated_arrival_date) { (Time.zone.today + 2.days) }
  let(:shipping_cost) { 12.99 }
  let(:quantity) { 11 }
  let(:tracking_code) { 'YY' }
  let(:payload) do
    {
      'estimated_arrival_date': estimated_arrival_date.to_s,
      'tracking_code': tracking_code,
      'shipper': {
        'shipment_provider_id': shipment_provider.id
      },
      'skus': [
        { 'id': sku.id, 'quantity': quantity }
      ],
      'shipping_cost': shipping_cost
    }
  end

  describe '.call' do
    context 'happy path' do
      it 'returns successful outcome' do
        expect(subject.success?).to be_truthy
      end

      it 'creates restocking shipment' do
        expect { subject }.to change { RestockingShipment.count }.by(1)
      end

      it 'creates restocking shipment item' do
        expect { subject }.to change { RestockingShipmentItem.count }.by(1)
      end

      it 'returns correct restocking shipment' do
        expect(subject.result).to have_attributes(
          {
            shipping_cost: shipping_cost,
            shipment_provider_id: shipment_provider.id,
            tracking_code: tracking_code,
            merchant_id: merchant.id
          }
        )
        expect(subject.result.estimated_arrival_date.to_date).to eq(estimated_arrival_date.to_date)
      end

      it 'returns correct restocking shipment item' do
        items = subject.result.restocking_shipment_items
        expect(items.count).to eq(1)
        item = items.first
        expect(item).to have_attributes(
          {
            sku_id: sku.id,
            quantity: quantity
          }
        )
      end
    end

    context 'with incorrect payload' do
      subject { described_class.call(merchant, incorrect_payload) }

      context 'shipping_cost is missing' do
        let(:incorrect_payload) do
          payload.except(:shipping_cost)
        end

        it 'returns failure outcome' do
          expect(subject.failure?).to be_truthy
        end

        it 'returns error message' do
          expect(subject.error).to eq('Validation failed: shipping_cost is missing')
        end

        it 'does not create restocking shipment' do
          expect { subject }.not_to(
            change{ RestockingShipment.count }
          )
        end

        it 'does not create restocking shipment item' do
          expect { subject }.not_to(
            change{ RestockingShipmentItem.count }
          )
        end
      end

      context 'wrong shipment provider id' do
        let(:incorrect_payload) do
          payload.merge(
            shipper: {
              shipment_provider_id: -1
            }
          )
        end

        it 'returns failure outcome' do
          expect(subject.failure?).to be_truthy
        end

        it 'returns error message' do
          expect(subject.error).to eq('Validation failed: Shipment provider must exist')
        end

        it 'does not create restocking shipment' do
          expect { subject }.not_to(
            change { RestockingShipment.count }
          )
        end

        it 'does not create restocking shipment item' do
          expect { subject }.not_to(
            change { RestockingShipmentItem.count }
          )
        end
      end

      context 'wrong sku id' do
        let(:incorrect_payload) do
          payload.merge(
            skus: [
              { quantity: 2, id: -1 }
            ]
          )
        end

        it 'returns failure outcome' do
          expect(subject.failure?).to be_truthy
        end

        it 'returns error message' do
          expect(subject.error).to eq('Validation failed: Sku must exist')
        end

        it 'does not create restocking shipment' do
          expect { subject }.not_to(
            change { RestockingShipment.count }
          )
        end

        it 'does not create restocking shipment item' do
          expect { subject }.not_to(
            change { RestockingShipmentItem.count }
          )
        end
      end

      context 'only one sku is wrong' do
        let(:incorrect_payload) do
          payload.merge(
            skus: [
              { quantity: 5, id: sku.id },
              { quantity: 2, id: -1 }
            ]
          )
        end

        it 'returns failure outcome' do
          expect(subject.failure?).to be_truthy
        end

        it 'returns error message' do
          expect(subject.error).to eq('Validation failed: Sku must exist')
        end

        it 'does not create restocking shipment' do
          expect { subject }.not_to(
            change { RestockingShipment.count }
          )
        end

        it 'does not create restocking shipment item' do
          expect { subject }.not_to(
            change { RestockingShipmentItem.count }
          )
        end
      end

      context 'arrival date is in the past' do
        let(:incorrect_payload) do
          payload.merge(
            estimated_arrival_date: (Date.today - 1.day).to_s
          )
        end

        it 'returns failure outcome' do
          expect(subject.failure?).to be_truthy
        end

        it 'returns error message' do
          expect(subject.error).to eq('Validation failed: estimated_arrival_date must not be in the past')
        end

        it 'does not create restocking shipment' do
          expect { subject }.not_to(
            change{ RestockingShipment.count }
          )
        end

        it 'does not create restocking shipment item' do
          expect { subject }.not_to(
            change { RestockingShipmentItem.count }
          )
        end
      end

      context 'arrival date is not a date' do
        let(:incorrect_payload) do
          payload.merge(
            estimated_arrival_date: 'not a date'
          )
        end

        it 'returns failure outcome' do
          expect(subject.failure?).to be_truthy
        end

        it 'returns error message' do
          expect(subject.error).to eq('Validation failed: estimated_arrival_date must be a date')
        end

        it 'does not create restocking shipment' do
          expect { subject }.not_to(
            change { RestockingShipment.count }
          )
        end

        it 'does not create restocking shipment item' do
          expect { subject }.not_to(
            change { RestockingShipmentItem.count }
          )
        end
      end

      context 'skus list is empty' do
        let(:incorrect_payload) do
          payload.merge(
            skus: []
          )
        end

        it 'returns failure outcome' do
          expect(subject.failure?).to be_truthy
        end

        it 'returns error message' do
          expect(subject.error).to eq('Validation failed: skus must not be empty')
        end

        it 'does not create restocking shipment' do
          expect { subject }.not_to(
            change { RestockingShipment.count }
          )
        end

        it 'does not create restocking shipment item' do
          expect { subject }.not_to(
            change { RestockingShipmentItem.count }
          )
        end
      end
    end
  end
end
