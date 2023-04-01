# frozen_string_literal: true

class CreateRestockingShipmentItems < ActiveRecord::Migration[6.0]
  def change
    create_table :restocking_shipment_items do |t|
      t.references :sku, null: false, foreign_key: true
      t.references :restocking_shipment, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
