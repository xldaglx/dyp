class AddNameToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :name, :string
  end
end
