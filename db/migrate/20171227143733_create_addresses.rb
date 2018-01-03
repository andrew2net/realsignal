class CreateAddresses < ActiveRecord::Migration[5.1]
  def change
    create_table :addresses do |t|
      t.references :user, foreign_key: true
      t.string :addr_line_1
      t.string :addr_line_2
      t.string :city
      t.string :state
      t.string :zip_code, limit: 12
      t.string :country
      t.string :phone, limit: 15
      t.string :phone_ext, limit: 5

      t.timestamps
    end
  end
end
