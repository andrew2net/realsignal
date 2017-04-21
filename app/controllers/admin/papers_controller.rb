class Admin::PapersController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def index
    respond_to do |f|
      f.html { render 'admin/main/index' }
      f.json { render json: Paper.all, only: attrs }
    end
  end

  def create
    render json: Paper.create(paper_params), only: attrs
  end

  def update
    render json: Paper.update(params[:id], paper_params), only: attrs
  end

  def destroy
    Paper.destroy params[:id]
    head :ok
  end

  protected
  def attrs
    [:id, :name, :tick_size, :tick_cost, :price_format]
  end

  def paper_params
    params.permit attrs
  end
end
