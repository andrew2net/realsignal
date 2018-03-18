FactoryBot.define do
  factory :recom_signal do
    transient do
      n 0
    end
    datetime { DateTime.now + ((n - 20) * 600).minutes }
    signal_type 'Open Buy'
    strategy

    factory :recom_signal_with_papers do
      after(:create) do |recom_signal, evaluator|
        tool = create :tool_with_papers
        tool.tool_papers.each do |tool_paper|
          create :signal_paper, recom_signal: recom_signal, paper: tool_paper.paper
        end
      end
    end
  end
end
