require "spec_helper"

describe BusinessesController do  
  describe "GET index" do
    it "sorts all businesses alphabetically" do
      set_current_user
      business1 = Fabricate(:business, name: "beta")
      business2 = Fabricate(:business, name: "alpha")
      get :index
      expect(assigns(:businesses)).to eq([business2, business1])
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
  
  describe "GET search" do
    before {set_current_user}
    let(:flipper) {Fabricate(:business, city: "Chicago")}
    
    it "sets @results for authenticated user" do
      get :search, search_term: 'chic'
      expect(assigns(:results)).to eq([flipper])
    end
  end
end