require "spec_helper"

describe Favorite do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:business) }
  
  describe "#category_name" do
    it "returns category name for associated business" do
      category = Fabricate(:category, name: "Junk")
      business = Fabricate(:business, category: category)
      favorite = Fabricate(:favorite, business: business)
      expect(favorite.category_name).to eq("Junk")
    end
  end
  
  describe "#category" do
    it "returns category of the business" do
      category = Fabricate(:category)
      business = Fabricate(:business, category: category)
      favorite = Fabricate(:favorite, business: business)
      expect(favorite.category).to eq(category)
    end
  end
end