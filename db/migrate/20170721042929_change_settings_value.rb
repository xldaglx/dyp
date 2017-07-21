class ChangeSettingsValue < ActiveRecord::Migration[5.0]
  def change
     change_column :settings, :value, :text
  end
end
