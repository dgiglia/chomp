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
  
  describe "#rating" do
    let(:business) {Fabricate(:business)}
    let(:user) {Fabricate(:user)}
    let(:favorite) {Fabricate(:favorite, user: user, business: business)}
    
    it "returns review rating if there is a review" do
      review = (Fabricate :review, user: user, business: business, rating: 4)
      expect(favorite.rating).to eq(4)
    end
    
    it "returns nil if there is no review" do
      expect(favorite.rating).to eq(nil)
    end
  end
  
  describe "#rating=" do
    let(:business) {Fabricate(:business)}
    let(:user) {Fabricate(:user)}
    let(:item) {Fabricate(:favorite, user: user, business: business)}
    
    it "changes the rating if review is present" do
      review = Fabricate(:review, user: user, business: business, rating: 2)
      item.rating = 4
      expect(item.reload.rating).to eq(4)
    end
    
    it "clears rating if review is present" do
      review = Fabricate(:review, user: user, business: business, rating: 2)
      item.rating = nil
      expect(item.reload.rating).to be_nil
    end
    
    it "creates review with rating if review is not present" do
      item.rating = 4
      expect(item.reload.rating).to eq(4)
    end
  end
end