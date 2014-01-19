class CommentsController < ApplicationController

  def create
    @project = Project.find(params[:project_id])
    @video = Video.find(params[:video_id])
    @comment = Comment.new(comment_params)
    @comment.user_id = current_user.id
    @comment.video_id = @video.id

    if @comment.save
      flash[:notice] = 'Comment was successfully added.'
      redirect_to project_video_path(@project, @video)
    else
      flash[:error] = 'asdfasd'
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body, :timecode_start, :timecode_end, :user_id, :video_id )
    end

end
