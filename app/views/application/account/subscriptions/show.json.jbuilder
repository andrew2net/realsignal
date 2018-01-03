json.(@subscription, :id, :created_at)
json.plan do
  json.(@subscription.subscription_type, :period, :price)
  json.portfolio do
    json.name @subscription.subscription_type.portfolio_strategy.name
  end
end
