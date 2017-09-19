class RemoveDescriptionFromSubscriptionType < ActiveRecord::Migration[5.0]
  def change
    remove_column :subscription_types, :description
  end
end
