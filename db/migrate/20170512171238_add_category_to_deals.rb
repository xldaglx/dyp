class AddCategoryToDeals < ActiveRecord::Migration[5.0]
  def change
    add_reference :deals, :category, foreign_key: true
  end
end
