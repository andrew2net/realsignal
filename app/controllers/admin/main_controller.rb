class Admin::MainController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def index
  end

end
