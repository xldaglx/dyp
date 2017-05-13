class AddRankToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :rank, :integer
  end
end
