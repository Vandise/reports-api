class ApplicationController < ActionController::API
  include Sorcery::Controller
  include Pundit

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, except: :create

  protected

  def skip_authorization_and_policy_scope
    skip_authorization
    skip_policy_scope
  end

  def access_token
    @access_token ||= request.headers['X-Reports-Token'] || params[:access_token]
  end

  def current_user
    current_api_key.user if current_api_key
  end

  def current_api_key
    @current_api_key ||= ApiKey.active.includes(user: [:company, :roles]).where(access_token: access_token).first
  end
end
