require 'spec_helper'

describe UsersController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe "GET show" do
    before {set_current_user}
    let(:user) {Fabricate(:user)}
    
    it "assigns user variable" do
      get :show, id: user.id
      expect(assigns(:user)).to eq(user)
    end
    
    it_behaves_like "require sign in" do
      let(:action) {get :show, id: user.id}
    end
  end
  
  describe "POST create" do
    context "with valid input" do
      before {post :create, user: Fabricate.attributes_for(:user)}
      
      it "creates the user" do        
        expect(User.count).to eq(1)
      end
      
      it {is_expected.to set_flash[:success]}
      
      it {is_expected.to redirect_to sign_in_path}
    end
      
    context "with invalid input" do
      before {post :create, user: {password: "password", name: "your name"}}
      
      it "does not create user" do        
        expect(User.count).to eq(0)
      end
      
      it {is_expected.to render_template(:new)} 
      
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end
  end
end
