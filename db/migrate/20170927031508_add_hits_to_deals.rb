class AddHitsToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :hits, :integer
  end
end
