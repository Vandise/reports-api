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
end
