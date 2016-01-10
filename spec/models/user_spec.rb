require "spec_helper"

describe User do
  it { is_expected.to have_many(:business_ownerships).with_foreign_key("owner_id").dependent(:destroy) }
  it { is_expected.to have_many(:businesses).through(:business_ownerships) }
  it { is_expected.to have_many(:reviews).order("created_at DESC").dependent(:destroy) }
  it { is_expected.to have_many(:favorites).order("created_at DESC").dependent(:destroy) }
  it { is_expected.to have_many(:recommendations).with_foreign_key("sender_id") }
  it { is_expected.to have_many(:leading_connections).order("created_at DESC").class_name("Connection").with_foreign_key("leader_id").dependent(:destroy) }
  it { is_expected.to have_many(:following_connections).order("created_at DESC").class_name("Connection").with_foreign_key("follower_id").dependent(:destroy) }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:state) }
  it { is_expected.to validate_uniqueness_of(:email) }
  
  it_behaves_like "tokenable" do
    let(:object) {Fabricate(:user)}
  end
  
  describe "#follow" do
    let(:user) {Fabricate(:user)}
    
    it "follows another user" do
      holly = Fabricate(:user)
      holly.follow(user)
      expect(holly.follows?(user)).to be true
    end
    
    it "does not follow oneself" do
      holly = Fabricate(:user)
      holly.follow(holly)
        expect(holly.follows?(holly)).to be false
    end
  end
end
