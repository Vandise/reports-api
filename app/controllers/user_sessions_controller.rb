require 'typhoeus/adapters/faraday'

class UserSessionsController < ApplicationController
  before_action :skip_authorization_and_policy_scope

  def create
    user = authenticate_user
    render json: {errors: 'login failed'}, status: :unauthorized
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
    body
  end
end