class VideosController < ApplicationController

  before_action :authorize_creator, only: [:new, :destroy]
  before_action :authorize_viewable, only: [:show]

  def new
    @project = Project.find(params[:project_id])
    @video = @project.videos.build
  end

  def create
    @project = Project.find(params[:project_id])
    @video = Video.new(project_params)
    @video.project_id = @project.id

    if @video.save
      flash[:success] = 'Video was uploaded successfully.'
      redirect_to project_path(@project)
    else
      flash[:error] = 'Please specify a valid file to upload.'
      render :new
    end
  end

  def show
    @video = Video.find(params[:id])
    @project = Project.find(params[:project_id])
    @comment = Comment.new
    @comments = @video.comments
  end

  def destroy
    @video = Video.find(params[:id])
    @project = Project.find(params[:project_id])

    @video.destroy
    flash[:notice] = 'Video has been removed from the project.'
    redirect_to project_path(@project)
  end

  private

    def project_params
      params.require(:video).permit(:video_file, :revision_number, :approved, :project_id)
    end

    def current_membership
      @current_membership ||= Membership.find_by(user: current_user, project_id:  params[:project_id])
    end

    def authorize_creator
      unless current_membership.creator?
        flash[:error] = 'You are not authorized to manage videos for this project.'
        redirect_to project_path(params[:project_id])
      end
    end

    def authorize_viewable
      if current_membership.nil?
        flash[:alert] = 'You are not authorized to view this project.'
        redirect_to projects_path
      end
    end

end
