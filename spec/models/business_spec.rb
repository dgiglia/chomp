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
end