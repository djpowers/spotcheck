class ProjectsController < ApplicationController

  before_action :authenticate_user!

  def index
    @projects = Project.all.where(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      flash[:notice] = 'Project was successfully created.'
      redirect_to @project
    else
      render 'new'
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  private

    def project_params
      params.require(:project).permit(:title, :description, :status, :due_date)
    end

end
