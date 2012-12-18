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

  test "should update the user name" do
    session[:user_id] = users(:one).id # Authenticated
    put :update, id: users(:one).id, user: {name: 'New Name'}
    assert_response :redirect
  end

  test "should delete the user account and all associed blogs" do
    session[:user_id] = users(:two).id # Authenticated
    @request.host = "comit.dev"
    assert_difference('User.count', -1) do
      post :destroy, id: users(:two).id
      assert_response :redirect
    end
  end
end
