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
      flash[:notice] = 'New user was successfully added to project.'
      redirect_to project_path(@project)
    else
      render 'new'
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    project = @membership.project

    @membership.destroy
    flash[:notice] = 'User has been removed from this project.'
    redirect_to project_path(project)
  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def update
    @membership = Membership.find(params[:id])

    if @membership.update_attributes(membership_params)
      flash[:notice] = 'User has been updated.'
      redirect_to project_path(@membership.project)
    else
      render 'edit'
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
