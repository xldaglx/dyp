class AddCrawlerToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :crawler, :integer
  end
end
