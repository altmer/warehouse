# frozen_string_literal: true

class CreateShipmentProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :shipment_providers do |t|
      t.string :name

      t.timestamps
    end
  end
end
