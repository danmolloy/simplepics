class MediaController < ApplicationController
  before_action :require_client
  def index
    @user = @client.user.to_h
    @images = APIParser.new(media: get_user_media).images
  end


  private
  def get_user_media
    @client.user_recent_media
  end

  def initialize_client
    return false unless session[:access_token]
    @client ||= Instagram.client(access_token: session[:access_token])
    session[:user_info] = @client.user
  end

  def require_client
    redirect_to root_url unless initialize_client
  end
end
