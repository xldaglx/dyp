class AddSlugToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :slug, :string
  end
end
