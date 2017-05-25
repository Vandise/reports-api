require 'typhoeus/adapters/faraday'

class UserSessionsController < ApplicationController
  before_action :skip_authorization_and_policy_scope

  def create
    if user = authenticate_user
      token = ApiKey.for_user!(user.id)
      render json: { token: token, user: user }
    else
      render json: { errors: 'login failed' }, status: :unauthorized
    end
  end

  private

  def authenticate_user
    authenticate_from_google if params[:token]
  end

  def authenticate_from_google
    token = params[:token]
    url =   "https://www.googleapis.com/oauth2/v3/tokeninfo?id_token=#{token}"

    conn = Faraday.new(url: url) do |faraday|
      faraday.adapter :typhoeus
    end
    resp = conn.get
    body = JSON.parse(resp.body, symbolize_names: true)
    if valid_google_response?(body)
      User.get_google_user(body)
    end
  end

  def valid_google_response?(body)
    client_id = config_option('google_application_id')
    return true if body[:aud] == client_id
    false
  end
end