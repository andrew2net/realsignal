class AddStrategyTypeDateIndexToRecomSignal < ActiveRecord::Migration[5.0]
  def change
    add_index :recom_signals, [:strategy_id, :signal_type, :datetime], unique: true
  end
end
