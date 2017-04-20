class AddNameToTool < ActiveRecord::Migration[5.0]
  def change
    add_column :tools, :name, :string
  end
end
