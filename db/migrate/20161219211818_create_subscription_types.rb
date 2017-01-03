class CreateSubscriptionTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :subscription_types do |t|
      t.integer :portid, limit: 4, null: false
      t.string :symid, limit: 10, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.text :description

      t.timestamps
    end
  end
end
