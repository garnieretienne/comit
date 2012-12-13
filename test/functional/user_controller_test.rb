require 'test_helper'

class UserControllerTest < ActionController::TestCase
  fixtures :users

  test "should redirect an non authenticated user" do
    get :show
    assert_response :redirect
  end

  test "should display profile for an authenticated user" do
    session[:user_id] = users(:one).id # Authenticated
    get :show
    assert_response :success
  end

end
