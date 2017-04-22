FactoryGirl.define do
  factory :paper do
    name 'EURUSD'
    tick_size 0.00001
    tick_cost 1
    price_format '10.5'
  end
end
