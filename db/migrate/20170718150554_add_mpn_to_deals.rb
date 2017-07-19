class AddMpnToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :mpn, :string
  end
end
