require "spec_helper"

describe Business do
  it { is_expected.to have_many(:reviews).order("created_at DESC").dependent(:destroy) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many(:favorites).dependent(:destroy) }
  it { is_expected.to have_many(:recommendations) }
  it { is_expected.to have_many(:business_ownerships).dependent(:destroy) }
  it { is_expected.to have_many(:owners).through(:business_ownerships) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:state) } 
  
  describe "#average_rating" do
    let(:business) {Fabricate(:business)}
    
    it "returns 0 if no reviews" do
      expect(business.average_rating).to eq(0)
    end
    
    it "returns an average rating to one decimal place if reviews" do
      review1 = Fabricate(:review, business: business, rating: 5)
      review2 = Fabricate(:review, business: business, rating: 1)
      review3 = Fabricate(:review, business: business, rating: 2)
      average = (5 + 1 + 2) / 3
      expect(business.average_rating).to eq(2.7)
    end
  end
  
  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Business.import
      Business.__elasticsearch__.refresh_index!
    end

    context "with name" do
      it "returns no results when there's no match" do
        cat = Fabricate(:category)
        Fabricate(:business, name: "Gordon's", category: cat)
        refresh_index

        expect(Business.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        cat = Fabricate(:category)
        hot_food = Fabricate(:business, category: cat)
        burgers = Fabricate(:business, category: cat)
        refresh_index

        expect(Business.search("").records.to_a).to eq []
      end

      it "returns an array of 1 business for name case insensitve match" do
        cat = Fabricate(:category)
        hot_food = Fabricate(:business, category: cat, name: "Hot Food")
        burgers = Fabricate(:business, category: cat, name: "Burgers")
        refresh_index

        expect(Business.search("food").records.to_a).to eq [hot_food]
      end

      it "returns an array of many businesses for title match" do
        cat = Fabricate(:category)
        hot_food = Fabricate(:business, category: cat, name: "Hot Food")
        burgers = Fabricate(:business, category: cat, name: "Hot Burgers")
        refresh_index

        expect(Business.search("hot").records.to_a).to match_array [hot_food, burgers]
      end
    end
  end
end