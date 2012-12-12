require 'test_helper'

class PostControllerTest < ActionController::TestCase

  test "should display a blog post" do
    @request.host = "test.comit.dev"
    get :show, year: '2012', month: '12', day: '05', title: 'Welcome_to_Comit'
    assert_response :success
    assert_select 'title', "Welcome to Comit - Testing", 'Title of the post not displayed'
  end

  test "should redirect on bad url" do
    @request.host = "test.comit.dev"
    get :show, year: '2012', month: '12', day: '05', title: 'Welcome'
    assert_response :redirect
  end

  test "should display the blog as a markdown plain text" do
    @request.host = "test.comit.dev"
    get :markdown, year: '2012', month: '12', day: '07', title: 'Simple'
    assert_response :success
    assert_equal @response.body, 'Hello World !
=============

Bonjour.
'
  end

end
