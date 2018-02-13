require 'rails_helper'

RSpec.describe Admin::ApiController, type: :controller do
  before :all do
    @strategy = create :strategy

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
      request.remote_addr = '94.180.118.28'
      post :create_signal, params: p
      # Second pos same signal should replace previous.
      post :create_signal, params: p
      expect(response.status).to eq 200
      expect(response.body).to be_empty
      datetime = DateTime.parse '20170420165033'
      signal = RecomSignal.find_by strategy_id: @strategy.id, datetime: datetime,
      signal_type: 'Open Buy'
      paper = Paper.find_by name: 'EURUSD'
      signal_paper = SignalPaper.find_by recom_signal_id: signal.id,
      paper_id: paper.id
      expect(signal_paper.price).to eq 3.345
      expect(RecomSignal.count).to eq 2
      expect(SignalPaper.count).to eq 4
    end

    it "don't accept signal if it breack allowed sequence" do
      datetime = DateTime.now
      p = { signals: [[
        'Strategy one',
        (datetime - 1.minute).strftime('%Y%m%d%H%M%S'),
        'Open Buy',
        [['EURUSD', 3.333], ['GOLD', 544.32]]
      ]].to_json}
      request.remote_addr = '94.180.118.28'
      expect { post :create_signal, params: p }.to change { RecomSignal.count }.by 1
      p = { signals: [[
        'Strategy one',
        datetime.strftime('%Y%m%d%H%M%S'),
        'Open Sell',
        [['EURUSD', 3.433], ['GOLD', 544.52]]
      ]].to_json}
      expect { post :create_signal, params: p }.to change { RecomSignal.count }.by 0
      expect(response.status).to eq 200
      expect(response.body).to include 'Allowed sequence is broken'
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
      request.remote_addr = '94.180.118.28'
      post :create_signal, params: p
      expect(response.status).to eq 200
      expect(response.body).to include('Strategy Strategy 1 not found')
    end

    it "dont allow put signals form other IPs" do
      p = { signals: [
        [
          'Strategy 1',
          '20170420165033',
          'Open Buy',
          [ ['EURUSD', 3.345], ['GOLD', 543.74] ]
        ]
      ].to_json}
      post :create_signal, params: p
      expect(response).to have_http_status :unauthorized
    end
  end
end
