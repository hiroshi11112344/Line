class AddBirthPartsToProfiles < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :birth_year, :integer
    add_column :profiles, :birth_month, :integer
    add_column :profiles, :birth_day, :integer
  end
end
