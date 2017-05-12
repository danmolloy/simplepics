require 'rails_helper'
include ERB::Util

RSpec.describe AuthController, type: :controller do
  describe 'GET #connect' do
    it "redirects to the Instagram auth url" do
      get :connect
      expect(response.location).to include('https://api.instagram.com/oauth/authorize')
    end
  end

  describe 'GET #callback' do
    before do
      class_double("Instagram", get_access_token: OpenStruct.new(access_token: 'token')).as_stubbed_const
      get :callback
    end
    it 'saves the access token in the session' do
      expect(session[:access_token]).to eq 'token'
    end
    it 'redirects to media#index' do
      expect(response).to redirect_to '/media'
    end
  end

  describe 'DELETE #destroy' do
    before do
      session[:access_token] = 'token'
      session[:user_info]    = 'info'
      delete :destroy
    end
    it "deletes session access token" do
      expect(session[:access_token]).to be nil
    end
    it "deletes session user info" do
      expect(session[:user_info]).to be nil
    end
    it "redirects to home#index" do
      expect(response).to redirect_to :root
    end
  end
end
