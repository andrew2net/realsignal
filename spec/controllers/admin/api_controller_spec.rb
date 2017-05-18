require 'rails_helper'

RSpec.describe Admin::ApiController, type: :controller do
  before :all do
    create :strategy

    portfolio = create(:portfolio_strategy,
                       name: 'Portfolio of strategies number two')

    tool = create :tool, name: 'EURUSD*1.5 + GOLD*3'
    create :tool_paper, paper: Paper.find_by(name: 'EURUSD'), tool: tool,
      volume: 1.5
    create :tool_paper, paper: Paper.find_by(name: 'GOLD'), tool: tool,
      volume: 3

    create :strategy, name: 'Strategy two', leverage: 100,
      portfolio_strategy: portfolio, tool: tool
  end

  describe 'PUT signal' do
    it 'create signals oly once' do
      p = { signals: [
        [
          'Strategy one',
          '20170420165033',
          'Open Buy',
          [ ['EURUSD', 3.345], ['GOLD', 543.74] ]
        ],
        [
          'Strategy two',
          '20170420165033',
          'Open Buy',
          [ ['EURUSD', 2.999], ['GOLD', 544.19] ]
        ]
      ].to_json}
      post :create_signal, params: p
      post :create_signal, params: p
      expect(response.status).to eq 200
      expect(response.body).to be_empty
      expect(RecomSignal.count).to eq 2
      expect(SignalPaper.count).to eq 4
    end
    it "return strategy not found" do
      p = { signals: [
        [
          'Strategy 1',
          '20170420165033',
          'Open Buy',
          [ ['EURUSD', 3.345], ['GOLD', 543.74] ]
        ]
      ].to_json}
      post :create_signal, params: p
      expect(response.status).to eq 200
      expect(response.body).to include('Strategy Strategy 1 not found')
    end
  end
end
