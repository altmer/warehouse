# frozen_string_literal: true

class CreateRestockingShipments < ActiveRecord::Migration[6.0]
  def change
    create_table :restocking_shipments do |t|
      t.references :shipment_provider, null: false, foreign_key: true
      t.references :merchant, null: false, foreign_key: true
      t.string :status
      t.float :shipping_cost

      t.timestamps
    end
  end
end
