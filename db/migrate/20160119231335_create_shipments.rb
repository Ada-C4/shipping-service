class CreateShipments < ActiveRecord::Migration
  def change
    create_table :shipments do |t|
      t.string :carrier
      t.integer :order_id
      t.string :speed
      t.decimal :rate
      t.string :delivery_date

      t.timestamps null: false
    end
  end
end
