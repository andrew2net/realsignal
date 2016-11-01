class Application::ApiController < ApplicationController
  def views
    render params[:view], layout: false
  end
end
