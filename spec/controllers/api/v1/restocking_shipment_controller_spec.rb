# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RestockingShipmentController, type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json' } }

  describe '#new' do
    let!(:user) { FactoryBot.create(:user) }
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

    context 'with happy path' do
      let(:shipment) { RestockingShipment.first }
      before do
        FactoryBot.create(:merchant_account, user: user, merchant: merchant)
      end

      it 'creates restocking shipment and returns it' do
        post '/api/v1/user/restocking_shipments', params: payload.to_json, headers: headers

        expect(response.code).to eq('200')
        expect(shipment).not_to be_nil
        json = JSON.parse(response.body)

        expect(json).to eq(
          {
            'success' => true,
            'payload' => {
              'id' => shipment.id,
              'status' => nil,
              'shipping_cost' => shipping_cost,
              'sku_count' => 1,
              'total_count' => 11,
              'restocking_shipment_items' => shipment.restocking_shipment_items.map do |item|
                {
                  'id' => item.id,
                  'quantity' => quantity,
                  'sku' => {
                    'id' => sku.id,
                    'name' => sku.name
                  }
                }
              end,
              'shipment_provider' => {
                'id' => shipment_provider.id,
                'name' => shipment_provider.name
              }
            }
          }
        )
      end
    end

    context 'with misconfigured merchant' do
      let(:shipment) { RestockingShipment.first }

      it 'returns error message' do
        post '/api/v1/user/restocking_shipments', params: payload.to_json, headers: headers

        expect(response.code).to eq('422')
        expect(shipment).to be_nil
        json = JSON.parse(response.body)

        expect(json).to eq(
          {
            'success' => false,
            'errors' => ['configure merchant']
          }
        )
      end
    end

    context 'with missing data' do
      let(:shipment) { RestockingShipment.first }
      let(:incorrect_payload) do
        payload.merge(
          skus: []
        )
      end

      before do
        FactoryBot.create(:merchant_account, user: user, merchant: merchant)
      end

      it 'returns error message' do
        post '/api/v1/user/restocking_shipments', params: incorrect_payload.to_json, headers: headers

        expect(response.code).to eq('422')
        expect(shipment).to be_nil
        json = JSON.parse(response.body)

        expect(json).to eq(
          {
            'success' => false,
            'errors' => ['Validation failed: skus must not be empty']
          }
        )
      end
    end
  end
end
