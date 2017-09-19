class AddPeriodToSubscriptionType < ActiveRecord::Migration[5.0]
  def change
    add_column :subscription_types, :period, :integer, null: false, default: 0
    add_reference :subscription_types, :portfolio_strategy, foreign_key: true
    remove_column :subscription_types, :portid
    remove_column :subscription_types, :symid
    reversible do |dir|
      dir.up do
        ps = PortfolioStrategy.first
        if ps
          SubscriptionType.update_all portfolio_strategy_id: ps.id
        else
          SubscriptionType.destroy_all
        end
        change_column_null :subscription_types, :portfolio_strategy_id, false
      end
    end
  end
end
