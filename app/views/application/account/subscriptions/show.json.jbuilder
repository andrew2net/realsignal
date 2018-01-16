json.(@subscription, :id, :name, :created_at)
json.plan do
  json.(@subscription.subscription_type, :id, :price)
  json.period "1 #{@subscription.subscription_type.period}"
  json.portfolio do
    json.name @subscription.subscription_type.portfolio_strategy.name
  end
end
