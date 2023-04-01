class AddEstimatedArrivalDateToRestockingShipments < ActiveRecord::Migration[6.0]
  def change
    add_column :restocking_shipments, :estimated_arrival_date, :datetime
  end
end
