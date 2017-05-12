require 'rails_helper'

RSpec.describe MediaController, type: :controller do
  let(:instagram) {class_double(Instagram)}
  let(:client)    {instance_double(Instagram::Client)}
  let(:parser)    {instance_double(APIParser)}

  before do
    allow(instagram).to receive(:client).and_return(Instagram::Client.new)
    allow_any_instance_of(Instagram::Client).to \
     receive(:user).and_return(Hash.new(one: 1))
    allow_any_instance_of(Instagram::Client).to \
     receive(:user_recent_media).and_return('recent media')
    allow_any_instance_of(APIParser).to \
     receive(:images).and_return([Image.new, Image.new, Image.new])
  end


    describe 'GET #index' do
      before do
        session[:access_token] = 'token'
        get :index
      end
      it "populates the @user" do
        get :index
        expect(assigns(:user)).to be_truthy
      end
      it "populates @images with Images" do
        expect(assigns(:images)).to all(be_instance_of Image)
      end
      it "renders the :index template" do
        expect(response).to render_template :index
      end
    end


  describe 'private methods' do
    controller do
      before_action :require_client
      def index
      end
    end
      describe '#get_user_media' do
        it "returns the users recent media" do
          controller.instance_variable_set(:@client, Instagram::Client.new)
          expect(controller.send(:get_user_media)).to eq 'recent media'
        end
      end

      describe '#initialize_client' do
        it "returns false if there is no access token in session" do
          session.delete(:access_token)
          expect(controller.send(:initialize_client)).to be false
        end
        it "creates an Instagram client" do
          session[:access_token] = 'token'
          controller.send(:initialize_client)
          expect(assigns[:client]).to be_instance_of Instagram::Client
        end
        it "populates the session user info" #do
        ### problem accessing session variable from this spec
        #   session.delete(:user_info)
        #   controller.send(:initialize_client)
        #   expect(session[:user_info]).to be true
        # end
      end

      describe '#require_client' do
        context 'user logged in' do
          it "does not redirect to root" do
            session[:access_token] = 'token'
            get :index
            expect(response).not_to redirect_to :root
          end
        end
        context 'user logged out' do
          it "redirects to root" do
            session.delete(:access_token)
            get :index
            expect(response).to redirect_to :root
          end
        end
      end
  end

end
