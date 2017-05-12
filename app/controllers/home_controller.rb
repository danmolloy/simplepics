class HomeController < ApplicationController
  def index
    @user = session[:user_info]
  end
end
