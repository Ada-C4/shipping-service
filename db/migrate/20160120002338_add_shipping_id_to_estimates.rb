class AddShippingIdToEstimates < ActiveRecord::Migration
  def change
    add_column(:estimates, :shipping_id, :integer)
  end
end
