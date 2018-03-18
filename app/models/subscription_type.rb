class SubscriptionType < ApplicationRecord
  belongs_to :portfolio_strategy, inverse_of: :subscription_types
  has_many :subscriptions, inverse_of: :subscription_type
  enum period: [:Week, :Month, :Year]

  # Select plans with strategies which user doesn't subscribe yet.
  def self.available(user)
    # Find ids of strategies user subscribed (only statuses processing and subscribed).
    subscribed_strategy_ids = PortfolioStrategy.joins(subscription_types: :subscriptions)
      .where(subscriptions: { user_id: user.id }).where('subscriptions.status IN (1,2)').ids
    
    where.not portfolio_strategy_id: subscribed_strategy_ids
  end
end
