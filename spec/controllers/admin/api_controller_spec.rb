require 'rails_helper'

RSpec.describe Admin::ApiController, type: :controller do

  it 'GET #views render view' do
    get :views, params: { view: 'main' }
    expect(response).to have_http_status :success
  end

  it 'GET #current_admin_email' do
    admin = create :admin
    sign_in admin
    get :current_admin_email
    expect(response).to have_http_status :success
    expect(response.body).to eq admin.email
  end

  describe 'POST #create_signal' do
    before :each do |example|
      unless example.metadata[:skip_set_ip]
        request.remote_addr = '94.180.118.28'
      end
      @portfolio = create :portfolio_strategy

      @strategy = create :strategy, portfolio_strategy: @portfolio

      tool = create :tool, name: 'EURUSD*1.5 + GOLD*3'
      create :tool_paper, paper: Paper.find_by(name: 'EURUSD'), tool: tool,
        volume: 1.5
      create :tool_paper, paper: Paper.find_by(name: 'GOLD'), tool: tool,
        volume: 3

      create :strategy, name: 'Strategy two', leverage: 100,
        portfolio_strategy: @portfolio, tool: tool
    end

    it 'create signals only once' do
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

      expect {
        expect {
          post :create_signal, params: p
          # Second pos same signal should replace previous.
          post :create_signal, params: p
        }.to change { SignalPaper.count }.by 4
      }.to change { RecomSignal.count }.by 2

      expect(response).to have_http_status :success
      expect(response.body).to be_empty

      datetime = DateTime.parse '20170420165033'
      signal = RecomSignal.find_by strategy_id: @strategy.id, datetime: datetime,
        signal_type: 'Open Buy'
      paper = Paper.find_by name: 'EURUSD'
      signal_paper = SignalPaper.find_by recom_signal_id: signal.id,
        paper_id: paper.id
      expect(signal_paper.price).to eq 3.345
    end

    it 'send signal to subscribers' do
      user = create :user, chat_id: 123456
      subscription_type = create :subscription_type, portfolio_strategy: @portfolio
      create(:subscription,
        user:              user,
        subscription_type: subscription_type,
        status:            :subscribed,
        end_date:          Date.today + 1.week
      )

      datetime = DateTime.now
      p = { signals: [[
        'Strategy one',
        (datetime - 1.minute).strftime('%Y%m%d%H%M%S'),
        'Open Buy',
        [['EURUSD', 3.333], ['GOLD', 544.32]]
      ]].to_json}

      expect(Telegram.bot).to receive(:send_message).with(
        chat_id: user.chat_id, text: kind_of(String), parse_mode: "Markdown"
      ).twice

      expect { post :create_signal, params: p }.to change { RecomSignal.count }.by 1

      p = { signals: [[
        'Strategy one',
        datetime.strftime('%Y%m%d%H%M%S'),
        'Close Buy',
        [['EURUSD', 3.433], ['GOLD', 544.52]]
      ]].to_json}

      expect { post :create_signal, params: p }.to change { RecomSignal.count }.by 1
    end

    it "don't accept signal if it breack allowed sequence" do
      datetime = DateTime.now
      p = { signals: [[
        'Strategy one',
        (datetime - 1.minute).strftime('%Y%m%d%H%M%S'),
        'Open Buy',
        [['EURUSD', 3.333], ['GOLD', 544.32]]
      ]].to_json}

      expect { post :create_signal, params: p }.to change { RecomSignal.count }.by 1

      p = { signals: [[
        'Strategy one',
        datetime.strftime('%Y%m%d%H%M%S'),
        'Open Sell',
        [['EURUSD', 3.433], ['GOLD', 544.52]]
      ]].to_json}
      expect { post :create_signal, params: p }.to change { RecomSignal.count }.by 0

      expect(response).to have_http_status :success
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
      post :create_signal, params: p
      expect(response).to have_http_status :success
      expect(response.body).to include('Strategy Strategy 1 not found')
    end

    it 'return paper not found' do
      p = { signals: [
        [
          'Strategy one',
          '20170420165033',
          'Open Buy',
          [ ['EURUSD', 3.345], ['APPL', 543.74] ]
        ]
      ].to_json}
      post :create_signal, params: p
      expect(response).to have_http_status :success
      expect(response.body).to include('Paper APPL not found')
    end

    it "dont allow put signals form other IPs", skip_set_ip: true do
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
