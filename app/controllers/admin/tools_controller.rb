class Admin::ToolsController < ApplicationController
  before_action :authenticate_admin_admin!
  layout 'admin'

  def index
    respond_to do |f|
      f.html { render 'admin/main/index' }
      f.json { render json: Tool.all_with_papers }
    end
  end

  def create
    @tool = Tool.create name: params[:name]
    tool_params[:papers].each do |p|
      @tool.tool_papers.create p
    end
  end

  def update
    tool_params[:papers].each do |p|
      tp = ToolPaper.find_or_initialize_by(
        tool_id: params[:id], paper_id: p[:paper_id])
      tp.update p
    end
    @tool = Tool.update params[:id], name: params[:name]
    paper_ids = tool_params[:papers].map {|el| el[:paper_id]}
    @tool.tool_papers.where.not(paper_id: paper_ids).destroy_all
    render :create, json: true
  end

  def destroy
    Tool.destroy params[:id]
    head :ok
  end

  private

  def tool_params
    params.permit :id, :name, papers: [:id, :paper_id, :volume]
  end
end
