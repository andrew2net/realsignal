class AddTwoCheckoutFieldsToSubscription < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :status, :integer, default: 0
    add_column :subscriptions, :sale_id, :string
  end
end
