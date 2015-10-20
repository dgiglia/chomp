describe PagesController do  
  describe "GET front" do
    before {set_current_user}
    
    it "redirects authenticated users to home page" do
      get :front
      expect(response).to redirect_to home_path
    end
  end
end