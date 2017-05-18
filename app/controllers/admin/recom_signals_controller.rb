class Admin::RecomSignalsController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def index
    respond_to do |f|
      f.html { render 'admin/main/index'}
      f.json { @recom_signals = RecomSignal.includes signal_papers: :paper }
    end
  end
end
