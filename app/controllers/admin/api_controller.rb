class Admin::ApiController < ApplicationController
  before_action :authenticate_admin_admin!, except: [:views]
  def views
    render params[:view], layout: false
  end
end
