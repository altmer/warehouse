class AddTrackingCodeToRestockingShipments < ActiveRecord::Migration[6.0]
  def change
    add_column :restocking_shipments, :tracking_code, :string
  end
end
