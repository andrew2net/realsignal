FactoryGirl.define do
  factory :recom_signal do
    datetime DateTime.now
    signal_type RecomSignal.signal_types['Open Buy']
  end
end
