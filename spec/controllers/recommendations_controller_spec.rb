require 'spec_helper'

describe RecommendationsController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET new" do
    let(:cat) {Fabricate(:category)}
    let(:business) {Fabricate(:business, category: cat)}
    before do
      set_current_user
      get :new, business_id: business.id
    end
    
    it "sets @recommendation to a new recommendation" do
      expect(assigns(:recommendation)).to be_a_new(Recommendation)
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
    
    context "with authenticated user" do
      let(:cat) {Fabricate(:category)}
      let(:business) {Fabricate(:business, category: cat)}
      let(:jane) {Fabricate(:user)}
      before do
        set_current_user(jane)
        post :create, recommendation: {recipient_email: "holly@example.com", recipient_name: "Holly"}, business_id: business.id
      end
      
      it "creates a recommendation associated with the business" do
        expect(Recommendation.first.business_id).to eq(business.id)
      end
      
      it "creates a recommendation assocuated with the signed in user" do
        expect(Recommendation.first.sender_id).to eq(jane.id)
      end
    end
    
    context "with valid input" do
      let(:cat) {Fabricate(:category)}
      let(:business) {Fabricate(:business, category: cat)}
      before do
        set_current_user
        post :create, recommendation: {recipient_email: "holly@example.com", recipient_name: "Holly"}, business_id: business.id
      end
      after {ActionMailer::Base.deliveries.clear}
      
      it "creates a recommendation" do
        expect(Recommendation.count).to eq(1)
      end
      
      it "sends an email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["holly@example.com"])
      end
      
      it {is_expected.to redirect_to business_path(business)}
      
      it {is_expected.to set_flash['success']}
    end
    
    context "with invalid input" do
      let(:cat) {Fabricate(:category)}
      let(:business) {Fabricate(:business, category: cat)}
      before do
        set_current_user
        post :create, recommendation: {recipient_name: "Holly"}, business_id: business.id
      end
      after {ActionMailer::Base.deliveries.clear}
      
      it "does not create a recommendation" do
        expect(Recommendation.count).to eq(0)
      end
      
      it "does not send an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
      it "sets @recommendation" do
        expect(assigns(:recommendation)).to be_present
      end
      
      it {is_expected.to render_template(:new)}
      
      it {is_expected.to set_flash.now['danger']}
    end
  end
end