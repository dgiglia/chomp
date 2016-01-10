require "spec_helper"

describe BusinessOwner::BusinessesController do
  it {is_expected.to use_before_action(:require_business_owner)}
  
  describe "PATCH update" do
    let(:owner) {Fabricate(:user)}
    let(:cat) {Fabricate(:category)}
    let(:bus) {Fabricate(:business, category: cat, name: "Pancake City")}
    let(:rel) {Fabricate(:business_ownership, owner_id: owner.id, business_id: bus.id, approved: true)}
    before do
      set_current_user(owner)
      rel = Fabricate(:business_ownership, owner_id: owner.id, business_id: bus.id, approved: true)
    end
    
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
end