class RemoveSubscriptionTypeFromRecomSignal < ActiveRecord::Migration[5.0]
  def change
    change_table :recom_signals do |t|
      t.remove :subscription_type_id, :recom, :sigdate, :price

      t.references :strategy, index: true, null: false, on_delete: :restrict
      t.integer :type_id, null: false
    end
  end
end
