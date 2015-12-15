describe FavoritesController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET index" do
    it "sets signed in user's favorites to @favorites" do
      set_current_user
      john = current_user
      favorite1 = Fabricate(:favorite, user: john)
      favorite2 = Fabricate(:favorite, user: john)
      get :index
      expect(assigns(:favorites)).to eq([favorite1, favorite2])
    end
    
    it_behaves_like "require sign in" do
        let(:action) {get :index}
    end
  end
  
  describe "POST create" do
    context "with authenticated user" do
      let(:hopper) {Fabricate(:business)}
      let(:jim) {Fabricate(:user)}
      before do
        session[:user_id] = jim.id
      end
      
      it "redirect to my favorites page" do
        post :create, business_id: hopper.id
        expect(response).to redirect_to favorites_path
      end

      it "create a favorite" do
        post :create, business_id: hopper.id
        expect(Favorite.count).to eq(1)
      end
      
      it "creates favorite that is associated with the business" do
        post :create, business_id: hopper.id
        expect(Favorite.first.business).to eq(hopper)
      end
      
      it "creates favorite that is associated with the signed in user" do
        post :create, business_id: hopper.id
        expect(Favorite.first.user).to eq(jim)
      end
      
      it "does not add business if already in queue" do
        Fabricate(:favorite, business: hopper, user: jim)
        post :create, business_id: hopper.id
        expect(jim.favorites.count).to eq(1)
      end
    end
    
    context "with unauthenticated user" do
      before {post :create}
      it {is_expected.to redirect_to root_path}
    end
  end
  
  describe "DELETE destroy" do
    context "with authenticated user" do
      let(:george) {current_user}
      let(:item1) {Fabricate(:favorite, user: george)}
      before {set_current_user}
      
      it "removes business from favorites for signed in user" do
        delete :destroy, id: item1.id
        expect(Favorite.count).to eq(0)
      end

      it "redirects to favorites for signed in user" do
        delete :destroy, id: item1.id
        expect(response).to redirect_to favorites_path
      end

      it "does not delete item if it is not in current user's queue" do
        susie = Fabricate(:user)
        item2 = Fabricate(:favorite, user: susie)
        delete :destroy, id: item2.id
        expect(susie.favorites.count).to eq(1)
      end
    end
    
    context "with unauthenticated user" do
      let(:item) {Fabricate(:favorite)}
      before {delete :destroy, id: item.id}
      
      it {is_expected.to redirect_to root_path}
    end
  end 
end