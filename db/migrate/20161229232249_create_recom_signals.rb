class CreateRecomSignals < ActiveRecord::Migration[5.0]
  def change
    create_table :recom_signals do |t|
      t.references :subscription_type, foreign_key: true, null: false
      t.string :recom, null: false
      t.datetime :sigdate, null: false
      t.decimal :price, precision: 12, scale: 2, null: false

      t.timestamps
    end
  end
end
