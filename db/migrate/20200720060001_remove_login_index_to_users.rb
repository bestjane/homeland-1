# frozen_string_literal: true

class RemoveLoginIndexToUsers < ActiveRecord::Migration[6.0]
  def up
    remove_index :users, name: 'index_users_on_login'
  end

  def down
    add_index :users, :login, name: 'index_users_on_login', using: :btree
  end
end
