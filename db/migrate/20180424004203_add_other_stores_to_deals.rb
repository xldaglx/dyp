class AddOtherStoresToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :walmart, :string
    add_column :deals, :amazon, :string
    add_column :deals, :elektra, :string
  end
end
