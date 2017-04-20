class CreatePortfolioStrategies < ActiveRecord::Migration[5.0]
  def change
    create_table :portfolio_strategies do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_reference :strategies, :portfolio_strategy, index: true,
      foreign_key: true, on_delete: :restrict
  end
end
