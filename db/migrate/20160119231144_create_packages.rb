class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.integer :weight
      t.string :dimensions

      t.timestamps null: false
    end
  end
end
