class Admin::ApiController < ApplicationController
  before_action :authenticate_admin_admin!, except: [:views, :create_signal]
  before_action :filter_ip_address, only: :create_signal

  def views
    render params[:view], layout: false
  end

  def current_admin_email
    render text: current_admin_admin.email
  end

  def create_signal
    resp = []
    data = params[:signals].gsub('\'', '"')
    signals = JSON.parse data

    signals.each do |s|
      strategy = Strategy.find_by name: s[0]
      unless strategy
        resp << "Strategy #{s[0]} not found"
        next
      end

      signal = nil
      ActiveRecord::Base.transaction do
        datetime = DateTime.parse s[1]
        signal = RecomSignal.find_or_initialize_by strategy_id: strategy.id,
          datetime: datetime
        signal.signal_type = RecomSignal.signal_types[s[2]]
        signal.save

        sp_ids = []
        s[3].each do |p|
          # paper = Paper.find_by name: p[0]
          tool_paper = strategy.tool.tool_papers.joins(:paper).find_by papers: { name: p[0] }
          unless tool_paper
            resp << "Paper #{p[0]} not found."
            next
          end
          sp = SignalPaper.find_or_initialize_by recom_signal_id: signal.id,
            paper_id: tool_paper.paper_id
          sp.update_attribute :price, p[1]
          sp_ids << sp.id
        end
        raise ActiveRecord::Rollback if signal.signal_papers.empty?
        signal.signal_papers.where.not(id: sp_ids).destroy_all
      end
      signal.notify_users if signal
    end
  rescue => e
    resp << e.message
    logger.fatal e.message
  ensure
    render plain: resp.join('; ')
  end

  protected

  def filter_ip_address
    current_ip_address = request.env['HTTP_X_REAL_IP'] || request.env['REMOTE_ADDR']
    head :unauthorized if current_ip_address != "94.180.118.28"
  end
end
