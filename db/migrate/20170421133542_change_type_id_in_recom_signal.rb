class ChangeTypeIdInRecomSignal < ActiveRecord::Migration[5.0]
  def change
    rename_column :recom_signals, :type_id, :type
  end
end
