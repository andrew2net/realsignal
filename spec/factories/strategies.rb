FactoryBot.define do
  factory :strategy do
    name 'Strategy one'
    leverage 10
    portfolio_strategy
    association :tool, factory: :tool_with_papers

    factory :strategy_with_recom_signals do
      transient { recom_signals_count 5 }
      after(:create) do |strategy, evaluator|

        # Create signal with wrong type sequence.
        create :recom_signal_with_papers, strategy: strategy, signal_type: 'Open Sell'

        signal_type = 'Open Buy'
        evaluator.recom_signals_count.times do |n|
          create :recom_signal_with_papers, strategy: strategy, signal_type: signal_type, n: n
          next_allowed_signalls = RecomSignal::SIGNAL_RULES[signal_type][:next_allowed]
          idx = rand next_allowed_signalls.size
          signal_type = next_allowed_signalls[idx]
        end
      end
    end
  end
end
