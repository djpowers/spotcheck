class ProjectsController < ApplicationController

  before_action :authenticate_user!
  before_action :authorize_user, only: [:show]

  def index
    @projects = current_user.projects
    @created_projects = current_user.memberships.where(role: 'creator').map{ |membership| membership.project }
    @collaborated_projects = current_user.memberships.where(role: 'collaborator').map{ |membership| membership.project }
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      @membership = current_user.memberships.build(project_id: @project.id, role: 'creator')
      @membership.save
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

    def authorize_user
      @project = Project.find(params[:id])
      unless user_signed_in? and @project.viewable_by?(current_user)
        redirect_to root_path, alert: 'Access Denied.'
      end
    end

end
