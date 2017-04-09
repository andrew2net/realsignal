class CreateToolPapers < ActiveRecord::Migration[5.0]
  def change
    create_table :tool_papers do |t|
      t.references :tool, foreign_key: true, null: false
      t.references :paper, foreign_key: true, null: false
      t.decimal :volume, precision: 2, scale: 1, null: false

      t.timestamps
    end
  end
end
