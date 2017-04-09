class TollPaperOnDelete < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :tool_papers, :tools
    add_foreign_key :tool_papers, :tools, on_delete: :cascade
  end
end
