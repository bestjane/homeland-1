# frozen_string_literal: true

class ChangeEmailMd5ToUsers < ActiveRecord::Migration[6.0]
  def up
    change_column :users, :email_md5, :string, null: true
  end

  def down
    change_column :users, :email_md5, :string, null: false
  end
end
