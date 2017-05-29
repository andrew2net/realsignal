class ToolPaperVolumeChange < ActiveRecord::Migration[5.0]
  def change
    change_column :tool_papers, :volume, :decimal, precision: 4, scale: 1
  end
end
