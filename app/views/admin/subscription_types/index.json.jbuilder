json.array! @subscription_types do |st|
  json.(st, :id, :portfolio_strategy_id, :price)
  json.period SubscriptionType.periods[st.period]
end
