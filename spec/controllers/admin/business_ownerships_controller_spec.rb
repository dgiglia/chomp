require "spec_helper"

describe Admin::BusinessOwnershipsController do
  it {is_expected.to use_before_action(:require_admin)}
  
  describe "PATCH approve" do
    let(:cat) {Fabricate(:category)}
    let(:bus) {Fabricate(:business, category: cat)}
    let(:jim) {Fabricate(:user)}
    let(:claim) {Fabricate(:business_ownership, business_id: bus.id, owner_id: jim.id)}
    after {ActionMailer::Base.deliveries.clear}
    before do
      set_current_admin
      patch :approve, id: claim
    end
      
    it "updates ownership attribute approved to true" do
      expect(claim.reload.approved).to be true
    end
    
    it "sends an approved email to the owner" do
        expect(ActionMailer::Base.deliveries.last.to).to eq([jim.email])
      end
    
    it {is_expected.to set_flash[:success]}
    
    it {is_expected.to redirect_to admin_admin_panel_path}
  end 
  
  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:cat) {Fabricate(:category)}
      let(:bus) {Fabricate(:business, category: cat)}
      let(:jim) {Fabricate(:user)}
      let(:claim) {Fabricate(:business_ownership, business_id: bus.id, owner_id: jim.id)}
      after {ActionMailer::Base.deliveries.clear}
      before {set_current_admin}
      
      it "removes ownership" do
        delete :destroy, id: claim
        expect(BusinessOwnership.count).to eq(0)
      end

      it "redirects to admin panel" do
        delete :destroy, id: claim
        expect(response).to redirect_to admin_admin_panel_path
      end
    end
    
    context "with unauthenticated user" do
      let(:cat) {Fabricate(:category)}
      let(:bus) {Fabricate(:business, category: cat)}
      let(:jim) {Fabricate(:user)}
      let(:claim) {Fabricate(:business_ownership, business_id: bus.id, owner_id: jim.id)}
      
      before {delete :destroy, id: claim.id}
      
      it {is_expected.to redirect_to root_path}
    end
  end
end

