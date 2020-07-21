class CreateUserSSO < ActiveRecord::Migration[5.0]
  def change
    create_table :user_ssos do |t|
      t.integer :user_id, null: false
      t.string :uid, null: false, limit: 255
      t.string :username, limit: 100
      t.string :email, limit: 100
      t.string :name, limit: 100
      t.string :avatar_url, limit: 255
      t.text :last_payload, null: false
      t.timestamps
    end

    add_index :user_ssos, :uid, unique: true
  end
end
