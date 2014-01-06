class ProjectsController < ApplicationController

  before_action :authenticate_user!

  def index
    @projects = Project.all #user only
  end

end
