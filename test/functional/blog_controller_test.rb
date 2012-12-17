require 'test_helper'

class BlogControllerTest < ActionController::TestCase
  fixtures :blogs

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should display the list of blog if no subdomain" do
    @request.host = "comit.dev"
    get :index
    assert_response :success
    assert_not_nil assigns(:blogs), "No blog listed (not executing 'all' method ?)"
    assert_nil assigns(:blog), "A blog is selected (not executing 'all' method ?)"
  end

  test "should display the list of blog if subdomain not registered" do
    @request.host = "xxx.comit.dev"
    get :index
    assert_response :redirect
  end

  test "should display the related blog if subdomain" do
    @request.host = "test.comit.dev"
    get :index
    assert_response :success
    assert_nil assigns(:blogs), "Blog list available (not executing 'show' method ?)"
    assert_not_nil assigns(:posts), "No blog selected (not executing 'show' method ?)"
  end

  test "should pull a git repo" do
    @request.host = "test.comit.dev"
    post :hook, token: blogs(:test).token
    assert_response :success
  end

  test "should not pull an non-existing git repo" do
    @request.host = "erased.comit.dev"
    post :hook, token: blogs(:erased).token
    assert_response :missing
  end

  test "should not pull a git repo if bad token is provided" do
    @request.host = "test.comit.dev"
    post :hook, token: 'badtoken'
    assert_response :missing
  end

  test "should create a blog" do
    session[:user_id] = users(:one).id # Authenticated
    @request.host = "comit.dev"
    assert_difference('Blog.count', 1) do
      post :create, blog: {
        name:      'New Blog',
        subdomain: 'newblog',
        git:       "#{Rails.root}/tmp/comit-test"
      }
      assert_response :redirect
    end
  end

  test "should NOT create a blog" do
    session[:user_id] = users(:one).id # Authenticated
    @request.host = "comit.dev"
    assert_difference('Blog.count', 0) do
      post :create, blog: {
        name:      'New Blog',
        subdomain: 'newblog',
        git:       "nothing"
      }
      assert_response :success
    end
  end

  test "should delete a blog" do
    session[:user_id] = users(:one).id # Authenticated
    @request.host = "comit.dev"
    assert_difference('Blog.count', -1) do
      post :destroy, id: blogs(:not_ready).id
      assert_response :redirect
    end
  end

  test "should edit a blog" do
    session[:user_id] = users(:one).id # Authenticated
    @request.host = "comit.dev"
    post :update, id: blogs(:not_ready).id, blog: {git: "#{Rails.root}/tmp/not_ready"}
    assert_response :redirect
    assert_not_equal blogs(:not_ready).path, assigns(:blog).path
  end

end