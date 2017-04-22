FactoryGirl.define do
  factory :strategy do
    name 'Strategy one'
    leverage 10
    portfolio_strategy
    association :tool, factory: :tool_with_papers
  end
end
