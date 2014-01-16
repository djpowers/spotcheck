class MembershipsController < ApplicationController

  before_action :authorize_creator, only: [:new, :edit, :destroy, :update]
  before_action :get_project, only: [:new, :create, :edit, :destroy]

  def new
    @membership = @project.memberships.build
  end

  def create
    @membership = @project.memberships.build(membership_params)
    @membership.user = User.find_by(email: params[:membership][:email])

    if @membership.save
      flash[:notice] = 'New user was successfully added to project.'
      redirect_to project_path(@project)
    else
      @membership.errors.add(:email, "must match email of a registered user.")
      render :new
    end
  end

  def destroy
    @membership = Membership.find(params[:id])

    @membership.destroy
    flash[:notice] = 'User has been removed from this project.'
    redirect_to project_path(@project)
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

    def get_project
      @project = Project.find(params[:project_id])
    end

    def current_membership
      @current_membership ||= Membership.find_by(user: current_user, project_id:  params[:project_id])
    end

    def authorize_creator
      unless current_membership.creator?
        flash[:notice] = 'You are not authorized to manage members in this group.'
        redirect_to project_path(params[:project_id])
      end
    end
end
