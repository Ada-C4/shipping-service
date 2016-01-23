class SwitchShippingToShipped < ActiveRecord::Migration
  def change
    rename_column(:packages, :shipping_id, :shipment_id)
  end
end
