class VideosController < ApplicationController

  before_action :authorize_creator, only: [:new]

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
      flash[:error] = 'Please specify a file to upload.'
      render :new
    end
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
        flash[:notice] = 'You are not authorized to upload videos for this project.'
        redirect_to project_path(params[:project_id])
      end
    end

end
