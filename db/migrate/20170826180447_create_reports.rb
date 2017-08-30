class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.string :description
      t.integer :typereport
      t.references :deal, foreign_key: true

      t.timestamps
    end
  end
end
