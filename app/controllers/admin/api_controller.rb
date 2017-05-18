class Admin::ApiController < ApplicationController
  before_action :authenticate_admin_admin!, except: [:views, :create_signal]

  def views
    render params[:view], layout: false
  end

  def create_signal
    resp = []
    begin
      data = params[:signals].gsub('\'', '"')
      signals = JSON.parse data

      signals.each do |s|
        strategy = Strategy.find_by name: s[0]
        unless strategy
          resp << "Strategy #{s[0]} not found"
          next
        end

        ActiveRecord::Base.transaction do
          datetime = DateTime.parse s[1]
          signal = RecomSignal.find_or_create_by strategy_id: strategy.id,
            datetime: datetime, signal_type: RecomSignal.signal_types[s[2]]

          sp_ids = []
          s[3].each do |p|
            paper = Paper.find_by name: p[0]
            unless paper
              resp << "Paper #{p[0]} not found."
              next
            end
            sp = SignalPaper.find_or_initialize_by recom_signal_id: signal.id,
              paper_id: paper.id
            sp.save price: p[0]
            sp_ids << sp.id
          end
          raise ActiveRecord::Rollback if signal.signal_papers.empty?
          signal.signal_papers.where.not(id: sp_ids).destroy_all
        end
      end
    rescue => e
      resp << e.message
      logger.fatal e.message
    end
    render plain: resp.join('; ')
  end

end
