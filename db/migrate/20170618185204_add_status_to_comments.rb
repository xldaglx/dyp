class AddStatusToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :status, :integer
  end
end
