# frozen_string_literal: true

class ChangeLoginToUsers < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :login, :string, null: false, default: '', limit: 100
  end

  def down
    change_column :users, :login, :string, null: false, limit: 100
  end
end
