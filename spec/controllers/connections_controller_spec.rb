require 'spec_helper'

describe ConnectionsController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET index" do
    it "sets @connections to current user's following connections" do
      julie = Fabricate(:user)
      set_current_user
      connection = Fabricate(:connection, follower: current_user, leader: julie)
      get :index
      expect(assigns(:connections)).to eq([connection])
    end
    
    it "sets @inverse_connections to current user's leading connections" do
      julie = Fabricate(:user)
      set_current_user
      connection = Fabricate(:connection, follower: julie, leader: current_user)
      get :index
      expect(assigns(:inverse_connections)).to eq([connection])
    end
    
    it_behaves_like "require sign in" do
      let(:action) {get :index}
    end
  end
  
  describe "POST create" do
    let(:gloria) {Fabricate(:user)}
    let(:john) {current_user}
    before {set_current_user}
    
    it "redirects to connections page" do
      post :create, leader_id: gloria.id
      expect(response).to redirect_to connections_path
    end
    
    it_behaves_like "require sign in" do
      let(:action) {post :create, leader_id: 3}
    end
    
    it "creates a connection with the current_user as the follower" do
      post :create, leader_id: gloria.id
      expect(john.following_connections.first.leader).to eq(gloria)
    end
    
    it "does not create a connection if the current user already follows that leader" do
      connection2 = Fabricate(:connection, leader: gloria, follower: john)
      post :create, leader_id: gloria.id
      expect(john.following_connections.count).to eq(1)
    end
    
    it "does not allow user to follow himself" do
      post :create, leader_id: john.id
      expect(john.following_connections.count).to eq(0)
    end
  end
  
  describe "DELETE destroy" do
    let(:gloria) {Fabricate(:user)}
    let(:john) {current_user}
    let(:connection) {Fabricate(:connection, follower: john, leader: gloria)}
    before {set_current_user}
    
    it "redirects to connections page" do
      delete :destroy, id: connection
      expect(response).to redirect_to connections_path
    end
    
    it "deletes connection if current user is follower" do
      delete :destroy, id: connection
      expect(john.following_connections.count).to eq(0)
    end
    
    it "does not delete connection if current user is leader" do
      connection2 = Fabricate(:connection, follower: gloria, leader: john)
      delete :destroy, id: connection2
      expect(john.leading_connections.count).to eq(1)
    end
    
    it_behaves_like "require sign in" do
      let(:action) {delete :destroy, id: 4}
    end
  end
end