class VideosController < ApplicationController

  def new
    @project = Project.find(params[:project_id])
    @video = @project.videos.build
  end

  def create
    @project = Project.find(params[:project_id])
    @video = Video.new(project_params)
    @video.project_id = @project.id

    if @video.save
      flash[:success] = 'Video was created successfully.'
      redirect_to project_path(@project)
    else
      flash[:error] = 'error!'
      render :new
    end
  end

  private

    def project_params
      params.require(:video).permit(:resource, :revision_number, :approved, :project_id)
    end

end
