require "spec_helper"

describe BusinessOwnership do
  it { is_expected.to belong_to(:owner).class_name("User"). with_foreign_key("owner_id") }
  it { is_expected.to belong_to(:business) }
  it { is_expected.to validate_presence_of(:contact_phone) }
  it { is_expected.to validate_presence_of(:contact_address) }
end