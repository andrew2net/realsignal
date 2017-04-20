class AddToolToStrategy < ActiveRecord::Migration[5.0]
  def change
    add_reference :strategies, :tool
    add_foreign_key :strategies, :tools, on_delete: :restrict
    remove_foreign_key :strategies, :portfolio_strategies
    add_foreign_key :strategies, :portfolio_strategies, on_delete: :restrict
  end
end
