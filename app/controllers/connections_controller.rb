class ConnectionsController < ApplicationController
  before_action :require_user
  
  def index
    @connections = current_user.following_connections
    @inverse_connections = current_user.leading_connections
  end
  
  def create
    leader = User.find(params[:leader_id])
    Connection.create(leader: leader, follower: current_user) if current_user.can_follow?(leader)
    redirect_to connections_path
  end
  
  def destroy
    connection = Connection.find(params[:id])
    connection.destroy if connection.follower == current_user
    redirect_to connections_path
  end
end