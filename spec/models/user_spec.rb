require "spec_helper"

describe User do
  it { is_expected.to have_many(:reviews) }
  it { is_expected.to have_many(:favorites) }
  it { is_expected.to have_many(:leading_connections).class_name("Connection").with_foreign_key("leader_id") }
  it { is_expected.to have_many(:following_connections).class_name("Connection").with_foreign_key("follower_id") }
  it { is_expected.to have_secure_password }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:email) }
end
