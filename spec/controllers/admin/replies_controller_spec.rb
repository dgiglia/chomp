require "spec_helper"

describe Admin::RepliesController do
  it {is_expected.to use_before_action(:require_admin)}
  
  describe "PATCH update" do
    let(:owner) {Fabricate(:user)}
    let(:user) {Fabricate(:user)}
    let(:cat) {Fabricate(:category)}
    let(:bus) {Fabricate(:business, category: cat)}
    let(:review) {Fabricate(:review, business: bus, user: user)}
    let(:reply) {Fabricate(:reply, review: review, user: owner)}
    before do          
      rel = Fabricate(:business_ownership, business: bus, owner: owner, approved: true)
      set_current_admin
    end

    context "with valid input" do
      before {patch :update, id: reply, reply: Fabricate.attributes_for(:reply, comment: "*edited for content*") }

      it "should update attributes of @review" do
        expect(reply.reload.comment).to eq("*edited for content*")
      end

      it {is_expected.to redirect_to business_path(reply.review.business)}

      it {is_expected.to set_flash[:success]}
    end

    context "with invalid input" do
      before {patch :update, id: reply, reply: Fabricate.attributes_for(:reply, comment: "") }

      it "should not update @reply" do
        expect(reply.reload.comment).not_to be_blank
      end

      it {is_expected.to render_template(:edit)}

      it {is_expected.to set_flash.now[:danger]}
    end
  end 

  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:owner) {Fabricate(:user)}
      let(:user) {Fabricate(:user)}
      let(:cat) {Fabricate(:category)}
      let(:bus) {Fabricate(:business, category: cat)}
      let(:review) {Fabricate(:review, business: bus, user: user)}
      let(:reply) {Fabricate(:reply, review: review, user: owner)}
      before do          
        rel = Fabricate(:business_ownership, business: bus, owner: owner, approved: true)
        set_current_admin
      end

      it "removes reply" do
        delete :destroy, id: reply.id
        expect(Reply.count).to eq(0)
      end

      it "redirects to business path" do
        delete :destroy, id: reply.id
        expect(response).to redirect_to business_path(review.business)
      end
    end

    context "with unauthenticated user" do
      let(:reply) {Fabricate(:reply)}
      before {delete :destroy, id: reply.id}

      it {is_expected.to redirect_to root_path}
    end
  end
end