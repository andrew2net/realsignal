class AddTokenIssuedAtToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :token_iat, :datetime
  end
end
