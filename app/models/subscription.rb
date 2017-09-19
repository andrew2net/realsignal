class Subscription < ApplicationRecord
  belongs_to :subscription_type, inverse_of: :subscriptions
  belongs_to :user, inverse_of: :subscriptions
end
