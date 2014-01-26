class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    projects_path
  end

  def current_membership
    @current_membership ||= Membership.find_by(user: current_user)
  end

  def authorize_creator
    unless current_membership.creator?
      flash[:notice] = 'You are not authorized to manage members or videos in this project.'
      redirect_to project_path(params[:project_id])
    end
  end

  protected

  def flash_message
    t("flash.#{controller_name}.#{action_name}")
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  end
end
