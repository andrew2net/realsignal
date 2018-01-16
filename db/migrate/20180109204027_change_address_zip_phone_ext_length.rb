class ChangeAddressZipPhoneExtLength < ActiveRecord::Migration[5.1]
  def change
    change_column :addresses, :zip_code, :string, limit: 16
    change_column :addresses, :phone, :string, limit: 16
    change_column :addresses, :phone_ext, :string, limit: 9
  end
end
