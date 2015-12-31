describe Admin::CategoriesController do  
  it {is_expected.to use_before_action(:require_admin)}
  
  describe "GET new" do
    it "sets @category" do
      set_current_admin
      get :new
      expect(assigns(:category)).to be_instance_of(Category)
    end

    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end
  end
  
  describe "POST create" do    
    context "with authenticated user" do      
      before {set_current_admin}
      let(:jenkins) {current_user}
      
      context "with valid input" do
        before {post :create, category: {name: "Mexican"}}
          
        it {is_expected.to redirect_to home_path}
        
        it {is_expected.to set_flash[:success]}
        
        it "creates a category" do
          expect(Category.count).to eq(1)
        end        
      end
      
      context "with invalid input" do
        before {post :create, category: {name: ""}}
        
        it {is_expected.to render_template(:new)}
        
        it "does not create a category" do
          expect(Category.count).to eq(0)
        end
      end
    end
    
    context "with unauthenticated user" do
      it_behaves_like "require sign in" do
        let(:action) {post :create, category: Fabricate.attributes_for(:category)}
      end
    end
  end
end