class MembershipsController < ApplicationController

  before_action :authorize_user, only: [:new]

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
    elsif @membership.errors.messages.values.flatten.include?('Membership already exists.')
      flash[:notice] = 'Membership already exists.'
      redirect_to project_path(@project)
    else
      flash[:notice] = "Please enter the email address of a registered user."
      redirect_to new_project_membership_path(@project)
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
    @membership = Membership.find_by(id: params[:id])

    if Membership.find_by(project: @membership.project, user: current_user).role == 'collaborator'
      flash[:notice] = 'You are not authorized to edit membership roles in this group.'
      redirect_to project_path(@membership.project)
    end
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

    def authorize_user
      @membership = Membership.find_by(user_id: current_user.id, project_id: params[:project_id])

      if @membership.nil?
        flash[:notice] = 'You are not a member of this group.'
        redirect_to projects_path
      elsif user_signed_in? and @membership.role == 'collaborator'
        flash[:notice] = 'You are not authorized to add members to this group.'
        redirect_to project_path(@membership.project)
      end
    end

    def user
      User.find_by(email: params[:membership][:email])
    end

end
