require 'spec_helper'

describe UsersController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
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
    
    context "sending emails" do
      before {ActionMailer::Base.deliveries.clear}
      after {ActionMailer::Base.deliveries.clear}
      
      it "sends out email to the user with valid inputs" do
        post :create, user: Fabricate.attributes_for(:user, email: "john@example.com")
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@example.com"])
      end
      
      it "sends out email containing the user's name with valid inputs" do
        post :create, user: Fabricate.attributes_for(:user, name: "john smith")
        expect(ActionMailer::Base.deliveries.last.body).to include("john smith")
      end
      
      it "does not send out email with invalid inputs" do
        post :create, user: {email: "john@example.com", name: "john smith"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
    
    context "with valid input and invitation" do
      let(:dean) {Fabricate(:user)}
      let(:invitation) {Fabricate(:invitation, inviter: dean, recipient_email: "sam@example.com")}
      let(:sam) {User.find_by(email: "sam@example.com")}
      before do
        ActionMailer::Base.deliveries.clear
        post :create, user: Fabricate.attributes_for(:user, email: "sam@example.com"), invitation_token: invitation.token
      end
      after {ActionMailer::Base.deliveries.clear}
      
      it "makes the user follow the inviter" do        
        expect(sam.follows?(dean)).to be true
      end
      
      it "makes the inviter follow the user" do
        expect(dean.follows?(sam)).to be true
      end
      
      it "expires the invitation upon acceptance" do
        expect(Invitation.first.token).to be nil
      end
      
      it "send an email to the inviter confirming their invite acceptance" do      
        expect(ActionMailer::Base.deliveries.last.to).to eq([dean.email])
        expect(ActionMailer::Base.deliveries.last.body).to include(invitation.recipient_name)
      end
    end
  end
  
  describe "GET new_with_invitation_token" do
    let(:invitation) {Fabricate(:invitation)}
    after {ActionMailer::Base.deliveries.clear}
    
    it "sets @user with recipient's email" do
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    
    it "renders new template" do
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template(:new)
    end 
    
    it "redirects to expired token page for invlaid tokens" do
      get :new_with_invitation_token, token: 'sodifhdoxkjvnklnvc'
      expect(response).to redirect_to expired_token_path
    end   
    
    it "sets @invitation_token" do
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
  end
end
