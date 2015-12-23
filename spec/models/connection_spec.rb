require 'spec_helper'

describe Connection do
  it { is_expected.to belong_to(:follower).class_name('User').with_foreign_key('follower_id') }
  it { is_expected.to belong_to(:leader).class_name('User').with_foreign_key('leader_id') }
end