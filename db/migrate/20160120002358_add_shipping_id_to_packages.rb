class AddShippingIdToPackages < ActiveRecord::Migration
  def change
    add_column(:packages, :shipping_id, :integer)
  end
end
