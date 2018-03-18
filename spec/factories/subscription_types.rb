FactoryBot.define do
  sequence :period do |n|
    idx = n % 3
    [:Week, :Month, :Year][idx]
  end

  factory :subscription_type do
    period :Month
    price "9.99"
    portfolio_strategy
  end
end
