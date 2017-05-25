class AddStoreToDeals < ActiveRecord::Migration[5.0]
  def change
    add_reference :deals, :store, foreign_key: true
  end
end
