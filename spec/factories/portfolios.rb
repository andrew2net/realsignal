FactoryBot.define do
  sequence :name do |n|
    "Portfolio of strategies ##{n}"
  end

  factory :portfolio_strategy do
    name

    factory :portfolio_strategy_with_subscription_types do
      after(:create) do |portfolio_strategy, evaluator|
        create_pair :subscription_type, portfolio_strategy: portfolio_strategy
      end
    end
  end
end
