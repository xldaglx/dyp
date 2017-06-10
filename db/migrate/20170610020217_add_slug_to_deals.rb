class AddSlugToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :slug, :string
  end
end
