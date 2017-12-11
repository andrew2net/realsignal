class ChangeUserChatIdTo64bit < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :chat_id, :integer, limit: 8
  end
end
