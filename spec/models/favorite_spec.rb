require "spec_helper"

describe Favorite do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:business) }
  it { is_expected.to delegate_method(:category).to(:business) }
  
  describe "#category" do
    it "returns category of the business" do
      category = Fabricate(:category)
      business = Fabricate(:business, category: category)
      favorite = Fabricate(:favorite, business: business)
      expect(favorite.category).to eq(category)
    end
  end
end