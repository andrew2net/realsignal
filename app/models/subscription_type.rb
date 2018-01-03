class SubscriptionType < ApplicationRecord
  belongs_to :portfolio_strategy, inverse_of: :subscription_types
  has_many :subscriptions, inverse_of: :subscription_type
  enum period: [:Week, :Month, :Year]
end
