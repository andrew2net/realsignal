class AddEndDateToSubscription < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :end_date, :date
  end
end
