require 'test_helper'

class SessionControllerTest < ActionController::TestCase
  OmniAuth.config.test_mode = true
  fixtures :users

  setup do
    OmniAuth.config.mock_auth[:one] = OmniAuth::AuthHash.new({
      provider: users(:one).provider,
      uid:      users(:one).uid, 
      info: {
        name:   users(:one).name
      }
    })
    OmniAuth.config.mock_auth[:unregistered] = OmniAuth::AuthHash.new({
      provider: 'github',
      uid:      '54321', 
      info: {
        name:   'Kurt Kobain'
      }
    })
  end

  test "should connect an user already registered" do
    @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:one]
    get :create, provider: 'github'
    assert_response :redirect
    assert_equal session['user_id'], users(:one).id
  end

  # >> Registration is closed for now
  #
  # test "should connect a new user and save it into the database" do
  #   @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:unregistered]
  #   get :create, provider: 'github'
  #   assert_response :redirect
  #   assert_not_nil session['user_id']
  #   user = User.find(session['user_id'])
  #   assert_equal user.name, "Kurt Kobain"
  # end

  test "should get destroy" do
    get :destroy
    assert_response :redirect
    assert_nil session['user_id']
  end

end
