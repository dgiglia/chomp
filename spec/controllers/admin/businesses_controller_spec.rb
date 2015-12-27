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
  end 
  
  describe "DELETE destroy" do
  end
end
