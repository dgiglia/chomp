require "spec_helper"

describe BusinessOwner::RepliesController do
  it {is_expected.to use_before_action(:require_business_owner)}
  
  describe "POST create" do
    context "with authenticated user" do    
      let(:owner) {Fabricate(:user)}
      let(:user) {Fabricate(:user)}
      let(:cat) {Fabricate(:category)}
      let(:bus) {Fabricate(:business, category: cat)}
      let(:review) {Fabricate(:review, business: bus, user: user)}
      before do          
        rel = Fabricate(:business_ownership, business: bus, owner: owner, approved: true)
        set_current_user(owner)
      end
      
      context "with valid input" do
        before {post :create, reply: Fabricate.attributes_for(:reply), review: review, owner: owner}
        
        it {is_expected.to redirect_to business_path(review.business)}
        it {is_expected.to set_flash[:success]}
        
        it "creates a reply" do
          expect(Reply.count).to eq(1)
        end
        
        it "creates a reply associated with the user" do
          expect(Reply.first.user).to eq(owner)
        end
        
        it "creates a reply associated with the review" do
          expect(Reply.first.review).to eq(review)
        end
      end
      
      context "with invalid input" do
        before {post :create, reply: Fabricate.attributes_for(:reply, comment: ""), review: review, owner: owner}

        it {is_expected.to render_template(:new)}
        it {is_expected.to set_flash.now[:danger]}
        
        it "does not create a reply" do
          expect(Reply.count).to eq(0)
        end
      end
    end
    
    context "with unauthenticated user" do
      let(:user) {Fabricate(:user)}
      let(:cat) {Fabricate(:category)}
      let(:bus) {Fabricate(:business, category: cat)}
      let(:review) {Fabricate(:review, business: bus, user: user)}
      
      it_behaves_like "require sign in" do
        let(:action) {post :create, reply: Fabricate.attributes_for(:reply), review: review}
      end
    end
  end
end