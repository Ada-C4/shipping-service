class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|

      t.timestamps null: false
    end
  end
end
