require "spec_helper"

describe Admin::BusinessesController do
  it {is_expected.to use_before_action(:require_admin)}
  
  describe "GET new" do
    it "sets @business" do
      set_current_admin
      get :new
      expect(assigns(:business)).to be_instance_of(Business)
    end

    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end
  end
  
  describe "POST create" do    
    context "with authenticated user" do      
      before {set_current_admin}
      let(:jenkins) {current_user}
      
      context "with valid input" do
        before {post :create, business: Fabricate.attributes_for(:business)}
          
        it {is_expected.to redirect_to home_path}
        
        it {is_expected.to set_flash[:success]}
        
        it "creates a business" do
          expect(Business.count).to eq(1)
        end        
      end
      
      context "with invalid input" do
        before {post :create, business: {name: "vgkh"}}
        
        it {is_expected.to render_template(:new)}
        
        it "does not create a business" do
          expect(Business.count).to eq(0)
        end
      end
    end
    
    context "with unauthenticated user" do
      it_behaves_like "require sign in" do
        let(:action) {post :create, business: Fabricate.attributes_for(:business)}
      end
    end
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

      it "redirects to business index" do
        delete :destroy, id: item1.id
        expect(response).to redirect_to home_path
      end
    end
    
    context "with unauthenticated user" do
      let(:item) {Fabricate(:business)}
      before {delete :destroy, id: item.id}
      
      it {is_expected.to redirect_to root_path}
    end
  end
end
