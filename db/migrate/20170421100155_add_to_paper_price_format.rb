class AddToPaperPriceFormat < ActiveRecord::Migration[5.0]
  def change
    add_column :papers, :price_format, :string, limit: 5
  end
end
