class AddBannedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :banned, :integer
  end
end
