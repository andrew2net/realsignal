class CreatePapers < ActiveRecord::Migration[5.0]
  def change
    create_table :papers do |t|
      t.string :name, limit: 8, null: false
      t.decimal :tick_size, precision: 6, scale: 5, null: false
      t.decimal :tick_cost, precision: 6, scale: 5, null: false

      t.timestamps
    end
  end
end
