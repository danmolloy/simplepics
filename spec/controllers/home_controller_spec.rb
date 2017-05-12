require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    it "assigns session user info to @user" do
      session[:user_info] = 'info'
      get :index
      expect(assigns(:user)).to eq 'info'
    end
    it "renders the :index template" do
      get :index
      expect(response).to render_template :index
    end
  end
end
