require "spec_helper"

describe BusinessesController do  
  describe "GET new" do
    it "sets @business" do
      set_current_user
      get :new
      expect(assigns(:business)).to be_a_new(Business)
    end

    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end
  end
  
  describe "GET index" do    
    before do
      set_current_user
      @business1 = Fabricate(:business, name: "delta", approved: true)
      @business2 = Fabricate(:business, name: "alpha", approved: false)
      @business3 = Fabricate(:business, name: "beta", approved: true)
      get :index
    end
    
    it "assigns businesses to approved businesses" do
      expect(assigns(:businesses)).not_to include(@business2)
    end
    
    it "sorts all businesses alphabetically" do      
      expect(assigns(:businesses)).to eq([@business3, @business1])
    end
  end
  
  describe "GET show" do
    before {set_current_user}
    let(:business) {Fabricate(:business)}
    
    it "assigns business variable" do
      get :show, id: business.id
      expect(assigns(:business)).to eq(business)
    end
    
    it "assigns reviews variable" do
      review1 = Fabricate(:review, business: business)
      review2 = Fabricate(:review, business: business)      
      get :show, id: business.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end
  end
      
  describe "POST create" do    
    context "with authenticated user" do      
      before {set_current_user}
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
        
        it {is_expected.to set_flash.now[:danger]}
        
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
  
  describe "GET search" do
    before {set_current_user}
    let(:flipper) {Fabricate(:business, city: "Chicago")}
    
    it "sets @results for authenticated user" do
      get :search, search_term: 'chic'
      expect(assigns(:results)).to eq([flipper])
    end
  end  
end