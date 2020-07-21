class AddTargetToReplies < ActiveRecord::Migration[5.0]
  def change
    add_column :replies, :action, :string, limit: 255
    add_column :replies, :target_type, :string, after: :action, limit: 100
    add_column :replies, :target_id, :string, after: :target_type, limit: 100
  end
end
