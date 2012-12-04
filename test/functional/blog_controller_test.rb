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
    assert_response :success
    assert_not_nil assigns(:blogs), "No blog listed (not executing 'all' method ?)"
    assert_nil assigns(:blog), "A blog is selected (not executing 'all' method ?)"
  end

  test "should display the related blog if subdomain" do
    @request.host = "blog.comit.dev"
    get :index
    assert_response :success
    assert_nil assigns(:blogs), "Blog list available (not executing 'show' method ?)"
    assert_not_nil assigns(:blog), "No blog selected (not executing 'show' method ?)"
  end

end
