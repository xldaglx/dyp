class CreateDeals < ActiveRecord::Migration[5.0]
  def change
    create_table :deals do |t|
      t.string :title
      t.string :description
      t.string :imagen
      t.string :link
      t.string :price
      t.string :expiration
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
