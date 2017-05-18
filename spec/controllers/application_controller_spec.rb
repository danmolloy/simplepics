require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def new
      raise Instagram::Error
    end

    def index
      raise Instagram::BadRequest
    end
  end


  describe "handling Instagram bad request" do
    it "flashes error message" do
      get :index
      expect(flash[:error]).not_to be_nil
    end
    it "redirects to logout action" do
      get :index
      expect(response).to redirect_to "/logout"
    end
  end

  describe "handling Instagram generic error" do
    it "flashes error message" do
      get :new
      expect(flash[:error]).not_to be_nil
    end

    it "redirects to root" do
      get :new
      expect(response).to redirect_to :root
    end
  end
end
