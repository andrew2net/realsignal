FactoryGirl.define do
  factory :tool do
    name 'EURUSD*1.0 - GOLD*2'
    factory :tool_with_papers do
      after :create do |tool, evaluator|
        create :tool_paper, tool: tool
        paper = create :paper, name: 'GOLD'
        create :tool_paper, tool: tool, paper: paper, volume: -2
      end
    end
  end
end
