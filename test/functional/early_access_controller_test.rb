require 'test_helper'

class EarlyAccessControllerTest < ActionController::TestCase

  test 'should create an early access' do
    assert_difference('EarlyAccess.count') do
      xhr :post, :create, {early_access: {email_address: 'email@domain.tld'}}
    end
  end

end
