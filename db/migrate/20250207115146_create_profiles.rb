class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :unique_id
      t.date :birthdate
      t.boolean :has_partner
      t.text :friend_requests
      t.text :friends

      t.timestamps
    end
  end
end
