class AddOfferToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :offer, :text
  end
end
