class AddBestbuyToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :bestbuy, :string
  end
end
