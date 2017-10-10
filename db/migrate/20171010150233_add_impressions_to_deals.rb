class AddImpressionsToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :impressions, :integer
  end
end
