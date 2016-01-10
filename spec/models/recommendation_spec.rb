require 'spec_helper'

describe Recommendation do
  it { is_expected.to belong_to(:sender).class_name('User').with_foreign_key("sender_id") }
  it { is_expected.to belong_to(:business) }
  it { is_expected.to validate_presence_of(:recipient_name) }
  it { is_expected.to validate_presence_of(:recipient_email) }
end