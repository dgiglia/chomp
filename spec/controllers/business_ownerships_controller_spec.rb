require "spec_helper"

describe BusinessOwnershipsController do  
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET new" do  
    let(:cat) {Fabricate(:category)}
    let(:business) {Fabricate(:business, category: cat)}
    before do
      set_current_user
      get :new, business_id: business.id
    end
    
    it "sets @business_ownership to a new ownership" do
      expect(assigns(:business_ownership)).to be_a_new(BusinessOwnership)
    end
    
    it "sets @business to the business" do
      expect(assigns(:business)).to eq(business)
    end
    
    it_behaves_like "require sign in" do
      let(:action) {get :new}
    end
  end
  
  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) {post :create}
    end
    
    context "with valid input" do
      let(:cat) {Fabricate(:category)}
      let(:business) {Fabricate(:business, category: cat)}
      let(:jim) {Fabricate(:user)}
      before do
        set_current_user(jim)
        post :create, business_ownership: Fabricate.attributes_for(:business_ownership), business_id: business.id
      end
      after {ActionMailer::Base.deliveries.clear}
      
      it "creates a business_ownership" do
        expect(BusinessOwnership.count).to eq(1)
      end
      
      it "creates a business_ownership associated with the business" do
        expect(BusinessOwnership.first.business_id).to eq(business.id)
      end
      
      it "creates a business_ownership associated with the signed in user" do
        expect(BusinessOwnership.first.owner_id).to eq(jim.id)
      end
      
      it "sends an email to the owner" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([jim.email])
      end
      
      it {is_expected.to redirect_to business_path(business)}
      
      it {is_expected.to set_flash['success']}
    end
    
    context "with invalid input" do
      let(:cat) {Fabricate(:category)}
      let(:business) {Fabricate(:business, category: cat)}
      before do
        set_current_user
        post :create, business_ownership: {contact_phone: "1234567890"}, business_id: business.id
      end
      after {ActionMailer::Base.deliveries.clear}
      
      it "does not create a business_ownership" do
        expect(BusinessOwnership.count).to eq(0)
      end
      
      it "does not send an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
      it "sets @business_ownership" do
        expect(assigns(:business_ownership)).to be_present
      end
      
      it {is_expected.to render_template(:new)}
      
      it {is_expected.to set_flash.now['danger']}
    end
  end
end