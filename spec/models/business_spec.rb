require "spec_helper"

describe Business do
  it { is_expected.to have_many(:reviews).order("created_at DESC").dependent(:destroy) }
  it { is_expected.to belong_to(:category) }
  it { is_expected.to have_many(:favorites).order("created_at DESC").dependent(:destroy) }
  it { is_expected.to have_many(:recommendations) }
  it { is_expected.to have_many(:business_ownerships).dependent(:destroy) }
  it { is_expected.to have_many(:owners).through(:business_ownerships) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:state) } 
  
  describe "#average_rating" do
    let(:business) {Fabricate(:business)}
    
    it "returns an average rating to one decimal place if reviews" do
      review1 = Fabricate(:review, business: business, rating: 5)
      review2 = Fabricate(:review, business: business, rating: 1)
      review3 = Fabricate(:review, business: business, rating: 2)
      expect(business.average_rating).to eq(2.7)
    end
  end
  
  describe "#owned?" do
    let(:cat) {Fabricate(:category)}
    let(:business) {Fabricate(:business, category: cat)}
    let(:owner) {Fabricate(:user)}
    
    it "is true if if a business has any owners whose associated business ownerships are approved" do
      Fabricate(:business_ownership, approved: true, business: business, owner: owner)
      expect(business.owned?).to be true
    end
    
    it "is false if a business has no approved business ownerships" do
      Fabricate(:business_ownership, approved: false, business: business, owner: owner)
      expect(business.owned?).to be false
    end
  end
  
  describe ".search", :elasticsearch do
    let(:refresh_index) do
      Business.import
      Business.__elasticsearch__.refresh_index!
    end

    context "with name" do
      let(:cat) {Fabricate(:category)}
      before do
        @hot_food = Fabricate(:business, category: cat, name: "Hot Food")
        @burgers = Fabricate(:business, category: cat, name: "Hot Burgers")
        refresh_index
      end

      it "returns no results when there's no match" do        
        expect(Business.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        expect(Business.search("").records.to_a).to eq []
      end

      it "returns an array of 1 business for name case insensitve match" do
        expect(Business.search("food").records.to_a).to eq [@hot_food]
      end

      it "returns an array of many businesses for name match" do       
        expect(Business.search("hot").records.to_a).to match_array [@hot_food, @burgers]
      end
    end
    
    context "with name, city, and state" do
      it "returns an array of many businesses based on name city state match" do
        cat = Fabricate(:category)
        hot_food = Fabricate(:business, category: cat, name: "Hot Food")
        city = Fabricate(:business, category: cat, city: "Hot city")
        state = Fabricate(:business, category: cat, state: "Hot state")
        refresh_index
        expect(Business.search("hot").records.to_a).to match_array [state, city, hot_food]
      end
    end

    context "multiple words must match" do
      it "returns an array of businesses where 2 words match name" do
        cat = Fabricate(:category)
        diner1 = Fabricate(:business, category: cat, name: "Penny Diner I")
        diner2 = Fabricate(:business, category: cat, name: "Penny Diner II")
        diner3 = Fabricate(:business, category: cat, name: "Star Diner")
        diner4 = Fabricate(:business, category: cat, name: "Penny Restaurant")        
        refresh_index
        expect(Business.search("Penny Diner").records.to_a).to match_array [diner1, diner2]
      end
    end
    
    context "with name, city, state and reviews" do
      let(:cat) {Fabricate(:category)}
      before do
        @star_diner = Fabricate(:business, category: cat, name: "Star Diner")
        @city = Fabricate(:business, city: "Star City", category: cat)
        @state = Fabricate(:business, state: "Star State", category: cat)
        @bird = Fabricate(:business, category: cat, name: "Birdfood")
        @bird_review = Fabricate(:review, business: @bird, comment: "5 star restaurant!")
        refresh_index
      end
      
      it 'returns an an empty array for no match with reviews option' do
        expect(Business.search("no_match", reviews: true).records.to_a).to eq([])
      end

      it 'returns an array of many businesss with relevance name > city > state > review' do
        expect(Business.search("star", reviews: true).records.to_a).to eq([@star_diner, @city, @state, @bird])
      end
    end  
    
    context "filter with average ratings" do
      let(:cat) { Fabricate(:category) }
      let(:penny1) { Fabricate(:business, category: cat, name: "Penny Diner 1") }
      let(:penny2) { Fabricate(:business, category: cat, name: "Penny Diner 2") }
      let(:penny3) { Fabricate(:business, category: cat, name: "Penny Diner 3") }

      before do
        Fabricate(:review, rating: 2, business: penny1)
        Fabricate(:review, rating: 4, business: penny1)
        Fabricate(:review, rating: 4, business: penny2)
        Fabricate(:review, rating: 2, business: penny3)
        refresh_index
      end

      context "with only average_rating_from" do
        it "returns an empty array when there are no matches" do
          expect(Business.search("Penny Diner", average_rating_from: 4.1).records.to_a).to eq []
        end

        it "returns an array of one businesses when there is one match" do
          expect(Business.search("Penny Diner", average_rating_from: 4.0).records.to_a).to eq [penny2]
        end

        it "returns an array of many businesses when there are multiple matches" do
          expect(Business.search("Penny Diner", average_rating_from: 3.0).records.to_a).to match_array [penny2, penny1]
        end
      end

      context "with only average_rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Business.search("Penny Diner", average_rating_to: 1.5).records.to_a).to eq []
        end

        it "returns an array of one business when there is one match" do
          expect(Business.search("Penny Diner", average_rating_to: 2.5).records.to_a).to eq [penny3]
        end

        it "returns an array of many businesss when there are multiple matches" do
          expect(Business.search("Penny Diner", average_rating_to: 3.4).records.to_a).to match_array [penny1, penny3]
        end
      end

      context "with both average_rating_from and average_rating_to" do
        it "returns an empty array when there are no matches" do
          expect(Business.search("Penny Diner", average_rating_from: 3.4, average_rating_to: 3.9).records.to_a).to eq []
        end

        it "returns an array of one business when there is one match" do
          expect(Business.search("Penny Diner", average_rating_from: 1.8, average_rating_to: 2.2).records.to_a).to eq [penny3]
        end

        it "returns an array of many businesss when there are multiple matches" do
          expect(Business.search("Penny Diner", average_rating_from: 2.9, average_rating_to: 4.1).records.to_a).to match_array [penny1, penny2]
        end
      end
    end
  end
end