class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.integer :price
      t.string :carrier
      t.string :service_name

      t.timestamps null: false
    end
  end
end
