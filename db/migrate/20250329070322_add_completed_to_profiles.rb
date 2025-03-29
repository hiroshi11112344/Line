class AddCompletedToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :completed, :boolean, default: false, null: false
  end
end
