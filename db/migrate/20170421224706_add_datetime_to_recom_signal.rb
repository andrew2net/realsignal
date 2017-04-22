class AddDatetimeToRecomSignal < ActiveRecord::Migration[5.0]
  def change
    add_column :recom_signals, :datetime, :datetime
  end
end
