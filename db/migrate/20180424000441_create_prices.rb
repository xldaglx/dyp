class CreatePrices < ActiveRecord::Migration[5.0]
  def change
    create_table :prices do |t|
      t.references :Deal, foreign_key: true
      t.integer :price
      t.string :store

      t.timestamps
    end
  end
end
