FactoryBot.define do
  factory :paper do
    name 'EURUSD'
    tick_size 0.00001
    tick_cost 1
    price_format '10.5'
    initialize_with { Paper.find_or_initialize_by(name: name) }
  end
end
