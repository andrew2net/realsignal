class AddRecomSignalPaperIndexToSignalPaper < ActiveRecord::Migration[5.0]
  def change
    add_index :signal_papers, [:recom_signal_id, :paper_id], unique: true
  end
end
