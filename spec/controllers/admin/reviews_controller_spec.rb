require "spec_helper"

describe Admin::ReviewsController do
  it {is_expected.to use_before_action(:require_admin)}
  
  describe "PATCH update" do
    let(:cat) {Fabricate(:category)}
    let(:bus) {Fabricate(:business, category: cat)}
    let(:rev) {Fabricate(:review, business_id: bus.id, comment: "These people are douchebags.")}
    before {set_current_admin}

    context "with valid input" do
      before {patch :update, id: rev, review: Fabricate.attributes_for(:review, comment: "*edited for content*") }

      it "should update attributes of @review" do
        expect(rev.reload.comment).to eq("*edited for content*")
      end

      it {is_expected.to redirect_to business_path(rev.business)}

      it {is_expected.to set_flash[:success]}
    end

    context "with invalid input" do
      before {patch :update, id: rev, review: Fabricate.attributes_for(:review, comment: "") }

      it "should not update @review" do
        expect(rev.reload.comment).not_to be_blank
      end

      it {is_expected.to render_template(:edit)}

      it {is_expected.to set_flash.now[:danger]}
    end
  end 

  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:george) {current_user}
      let(:cat) {Fabricate(:category)}
      let(:bus) {Fabricate(:business, category: cat)}
      let(:rev) {Fabricate(:review, business: bus)}
      before {set_current_admin}

      it "removes review" do
        delete :destroy, id: rev.id
        expect(Review.count).to eq(0)
      end

      it "redirects to business path" do
        delete :destroy, id: rev.id
        expect(response).to redirect_to business_path(rev.business)
      end
    end

    context "with unauthenticated user" do
      let(:rev) {Fabricate(:review)}
      before {delete :destroy, id: rev.id}

      it {is_expected.to redirect_to root_path}
    end
  end
end