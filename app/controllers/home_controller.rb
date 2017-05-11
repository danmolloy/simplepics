class HomeController < ApplicationController
  def index
    @user = session[:user_info]
  end

  def privacy
  end
end
