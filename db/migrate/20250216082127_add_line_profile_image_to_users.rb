class AddLineProfileImageToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :line_profile_image_url, :string
  end
end
