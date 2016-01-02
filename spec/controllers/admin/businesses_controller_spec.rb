require "spec_helper"

describe Admin::BusinessesController do
  it {is_expected.to use_before_action(:require_admin)}
  
  describe "PATCH approve_business" do
    let(:cat) {Fabricate(:category)}
    let(:bus) {Fabricate(:business, category: cat, approved: false)}
    before do
      set_current_admin
      patch :approve_business, id: bus
    end
      
    it "updates business attribute approved to true" do
      expect(bus.reload.approved).to be true
    end
    
    it {is_expected.to redirect_to admin_admin_panel_path}
  end
  
  describe "PATCH update" do
    let(:cat) {Fabricate(:category)}
    let(:bus) {Fabricate(:business, category: cat, name: "Pancake City")}
    before {set_current_admin}
    
    context "with valid input" do
      before {patch :update, id: bus, business: Fabricate.attributes_for(:business, name: "Pancakarama") }
      
      it "should update attributes of @business" do
        expect(bus.reload.name).to eq("Pancakarama")
      end
      
      it {is_expected.to redirect_to business_path(bus)}
      
      it {is_expected.to set_flash[:success]}
    end
    
    context "with invalid input" do
      before {patch :update, id: bus, business: {name: "Pancakes", state: ""}}
      
      it "should not update @business" do
        expect(bus.reload.name).not_to eq("Pancakes")
      end
      
      it {is_expected.to render_template(:edit)}
      
      it {is_expected.to set_flash.now[:danger]}
    end
  end 
  
  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:george) {current_user}
      let(:cat) {Fabricate(:category)}
      let(:item1) {Fabricate(:business, category: cat)}
      before {set_current_admin}
      
      it "removes business" do
        delete :destroy, id: item1.id
        expect(Business.count).to eq(0)
      end

      it "redirects to admin panel" do
        delete :destroy, id: item1.id
        expect(response).to redirect_to admin_admin_panel_path
      end
    end
    
    context "with unauthenticated user" do
      let(:item) {Fabricate(:business)}
      before {delete :destroy, id: item.id}
      
      it {is_expected.to redirect_to root_path}
    end
  end
end
