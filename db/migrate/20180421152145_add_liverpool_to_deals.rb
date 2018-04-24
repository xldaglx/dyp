class AddLiverpoolToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :liverpool, :string
  end
end
