class AddStatusToDeals < ActiveRecord::Migration[5.0]
  def change
    add_column :deals, :status, :integer
  end
end
