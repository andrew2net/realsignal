class ChangeRecomSignalIndexToStrategyDate < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :signal_papers, :recom_signals
    add_foreign_key :signal_papers, :recom_signals, on_delete: :cascade
    reversible do |dir|
      dir.up do
        RecomSignal.select(:strategy_id, :datetime)
        .group(:strategy_id, :datetime).having('count(*)>1')
        .pluck(:strategy_id, :datetime).each do |sig_data|
          valid = RecomSignal.where(strategy_id: sig_data[0], datetime: sig_data[1])
          .order(created_at: :desc).first
          RecomSignal.delete_all(['strategy_id=? AND datetime=? AND id<>?',
            sig_data[0], sig_data[1], valid.id])
        end
      end
    end
    remove_index :recom_signals, column: [:strategy_id, :signal_type, :datetime]
    add_index :recom_signals, [:strategy_id, :datetime], unique: true
  end
end
