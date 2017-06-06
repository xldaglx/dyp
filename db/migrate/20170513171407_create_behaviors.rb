class CreateBehaviors < ActiveRecord::Migration[5.0]
  def change
    create_table :behaviors do |t|
      t.integer :grade
      t.references :user, foreign_key: true
      t.references :deal, foreign_key: true

      t.timestamps
    end
  end
end
