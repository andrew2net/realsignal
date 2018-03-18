class Admin::ApiController < ApplicationController
  before_action :authenticate_admin_admin!, except: [:views, :create_signal]
  before_action :filter_ip_address, only: :create_signal

  # GET /admin/api/views/:view
  def views
    render params[:view], layout: false
  end

  # GET /admin/api/current_admin_email
  def current_admin_email
    render plain: current_admin_admin.email
  end

  # POST /admin/api/create_signal
  def create_signal
    resp = []
    data = params[:signals].gsub('\'', '"')
    # Signals - [[strategy, time, type, [[paper, prise],...],...]
    signals = JSON.parse data

    signals.each do |s|
      # Find strategy. If not found, add message to response and go to next signal.
      strategy = Strategy.find_by name: s[0]
      unless strategy
        resp << "Strategy #{s[0]} not found"
        next
      end

      signal = nil
      begin
        ActiveRecord::Base.transaction do
          signal = RecomSignal.create_signal strategy_id: strategy.id, signal_type: s[2], time: s[1]

          sp_ids = []
          s[3].each do |p|
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
      rescue => e
        resp << e.message
        logger.fatal e.message
      end
    end
    render plain: resp.join('; ')
  end

  protected

  def filter_ip_address
    current_ip_address = request.env['HTTP_X_REAL_IP'] || request.env['REMOTE_ADDR']
    head :unauthorized if current_ip_address != "94.180.118.28"
  end
end
