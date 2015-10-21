describe CategoriesController do
  it {is_expected.to use_before_action(:require_user)}
  
  describe "GET show" do
    before {set_current_user}
    let(:category) {Fabricate(:category)}
    
    it "assigns category variable" do
      get :show, id: category.id
      expect(assigns(:category)).to eq(category)
    end
  end
end