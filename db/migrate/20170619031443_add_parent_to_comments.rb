class AddParentToComments < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :parent, :integer
  end
end
