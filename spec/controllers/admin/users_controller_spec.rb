require "spec_helper"

describe Admin::UsersController do
  it {is_expected.to use_before_action(:require_admin)} 
  
  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:user) {Fabricate(:user)}
      let(:admin) {Fabricate(:admin)}
      before {set_current_admin(admin)}
      
      it "removes user" do
        delete :destroy, id: user.id
        expect(User.all).to eq([admin])
      end

      it "redirects to home page" do
        delete :destroy, id: user.id
        expect(response).to redirect_to home_path
      end
    end
    
    context "with unauthenticated user" do
      let(:user) {Fabricate(:user)}
      before {delete :destroy, id: user.id}
      
      it {is_expected.to redirect_to root_path}
    end
  end
end