require "spec_helper"

describe ReviewsController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "POST create" do
    let(:business) {Fabricate(:business)}
    
    context "with authenticated user" do      
      before {set_current_user}
      let(:jenkins) {current_user}
      
      context "with valid input" do
        before {post :create, review: Fabricate.attributes_for(:review), business_id: business.id}
          
        it {is_expected.to redirect_to business}
        
        it "creates a review" do
          expect(Review.count).to eq(1)
        end
        
        it "creates review associated with the business" do
          expect(Review.first.business).to eq(business)
        end
        
        it "creates review associated with the user" do
          expect(Review.first.user).to eq(jenkins)
        end        
      end
      
      context "with invalid input" do
        before {post :create, review: {comment: "vgkh"}, business_id: business.id}
        
        it {is_expected.to render_template("businesses/show")}
        
        it "does not create a review" do
          expect(Review.count).to eq(0)
        end
        
        it "sets @business" do
          expect(assigns(:business)).to eq(business)
        end
        
        it "sets @reviews" do
          review1 = Fabricate(:review, business: business)
          post :create, review: {comment: "vgkh"}, business_id: business.id
          expect(assigns(:reviews)).to match_array([review1])
        end
      end
    end
    
    context "with unauthenticated user" do
      it_behaves_like "require sign in" do
        let(:action) {post :create, review: Fabricate.attributes_for(:review), business_id: business.id}
      end
    end
  end
end