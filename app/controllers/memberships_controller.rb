class MembershipsController < ApplicationController

  # def index
  #   @project = Project.find(params[:project_id])
  # end

  def new
    @project = Project.find(params[:project_id])
    @membership = @project.memberships.build
  end

  def create
    @project = Project.find(params[:project_id])
    @membership = @project.memberships.build(membership_params)
    @membership.user = user
    if @membership.save
      redirect_to project_path(@project), flash_message
    else
      render 'new'
    end
  end

  private

  def membership_params
    params.require(:membership).permit(:role)
  end

  def user
    User.find_by(email: params[:membership][:email])
  end

end
