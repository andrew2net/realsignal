# encoding: UTF-8

class Subscription < ApplicationRecord
  belongs_to :subscription_type, inverse_of: :subscriptions
  belongs_to :user, inverse_of: :subscriptions

  def name
    "#{subscription_type.portfolio_strategy.name}"\
    " #{subscription_type.price}€/#{subscription_type.period}"
  end
end
