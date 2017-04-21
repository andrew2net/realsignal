class CreateSignalPapers < ActiveRecord::Migration[5.0]
  def change
    create_table :signal_papers do |t|
      t.references :recom_signal, foreign_key: true, null: false,
        on_delete: :restrict
      t.references :paper, foreign_key: true, null: false, on_delete: :restrict
      t.float :price
    end
  end
end
