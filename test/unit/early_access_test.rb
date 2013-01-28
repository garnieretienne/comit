require 'test_helper'

class EarlyAccessTest < ActiveSupport::TestCase
  
  test 'should register an early access' do
    access = EarlyAccess.new(email_address: 'kurt@comit.io')
    assert access.save, "correct email not saved as early_access"
  end

  test 'should not register a bad email address' do
    bad_access = EarlyAccess.new(email_address: 'kurtcomit.io')
    assert !bad_access.save, "bad-formatted email saved as early_access"
    assert_equal "is invalid", bad_access.errors.messages[:email_address].first
  end

  test 'an email address can only be registered once' do
    access = EarlyAccess.new(email_address: 'kurt@comit.io')
    assert access.save, "correct email not saved as early_access"
    same_access = EarlyAccess.new(email_address: 'kurt@comit.io')
    assert !same_access.save, "duplicate email address"
    assert_equal "is already registered", same_access.errors.messages[:email_address].first
  end
end
