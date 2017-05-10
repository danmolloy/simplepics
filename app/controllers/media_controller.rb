class MediaController < ApplicationController
  before_action :require_client
  def index
    @user = @client.user
    @images = APIMediaParser.new(media: get_user_media).images
  end


  private
  def get_user_media
    @client.user_recent_media
  end

  def initialize_client
    @client ||= Instagram.client(access_token: session[:access_token])
  end

  def require_client
    redirect_to root_url unless initialize_client
  end
end
