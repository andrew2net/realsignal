class ChangeTypeInRecomSignal < ActiveRecord::Migration[5.0]
  def change
    rename_column :recom_signals, :type, :signal_type
  end
end
