class CreateBanners < ActiveRecord::Migration[5.0]
  def change
    create_table :banners do |t|
      t.string :alt
      t.string :link
      t.integer :impressions
      t.integer :hits

      t.timestamps
    end
  end
end
