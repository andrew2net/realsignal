json.array! @plans do |plan|
  json.(plan, :id, :period, :price)
  json.portfolio do
    json.name plan.portfolio_strategy.name
  end
end
