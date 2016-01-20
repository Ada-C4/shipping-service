class SwitchingShippedToShipmentEstimate < ActiveRecord::Migration
  def change
    rename_column(:estimates, :shipping_id, :shipment_id)
  end
end
