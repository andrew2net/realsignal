require 'rails_helper'

RSpec.describe Admin::RecomSignalsController, type: :controller do
  render_views

  describe "GET #index" do
    it "returns http success" do
      request.accept = "application/json"
      admin = create :admin
      paper = create :paper, name: 'EURUSD'
      tool = create :tool
      create :tool_paper, tool: tool, paper: paper
      strategy = create :strategy, tool: tool
      date = DateTime.now.utc
      recom_signal = create :recom_signal, strategy: strategy, datetime: date,
      signal_type: 'Open Buy'
      create :signal_paper, paper: paper, recom_signal: recom_signal, price: 2
      sign_in admin
      get :index, format: :json
      expect(response).to have_http_status(:success)
      expect(response.body).to include_json([
          {
            datetime: (be >= date.strftime('%Y-%m-%dT%H:%M:%S.%LZ')),
            signal_type: 'Open Buy',
            papers: [
              price: 2,
              name: 'EURUSD'
            ]
          }
        ])
    end
  end

end
