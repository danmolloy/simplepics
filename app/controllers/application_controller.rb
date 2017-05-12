class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from Instagram::BadRequest, with: :bad_request
  rescue_from Instagram::Error, with: :generic_error

  private
  def bad_request(exception)
    flash[:error] = 'Authentication with Instagram failed. Please try again.'
    redirect_to '/logout'
  end
  def generic_error(exception)
    puts exception
    flash[:error] = 'Sorry, something went wrong. Please try again later.'
    redirect_to :root
  end
end
