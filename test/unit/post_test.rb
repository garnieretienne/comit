require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  def setup
    @source = ' 
# My blog post !
Hello Post !
'
  end

  test "should build a blog post" do
    date  = Date.new
    title = "Hello !"
    post  = Post.new(date: date, title: title)
    authors = [{name: 'Me', email: 'me@mail.com'}]
    assert_equal post.date, date, 'Date attribute is not accessible'
    assert_equal post.title, title, 'Title attribute is not accessible'
  end

  test "should not validate blog post without source" do
    post  = Post.new(
      date:    Date.new, 
      title:   "Hello !",
      authors: [{name: 'Me', email: 'me@mail.com'}]
    )
    assert !post.valid?, 'Post validated whit no source'
    assert_equal post.errors[:source], "can't be nil"
  end

  test "should not validate blog post without date" do
    post  = Post.new(
      source:  @source,
      title:   "Hello !",
      authors: [{name: 'Me', email: 'me@mail.com'}]
    )
    assert !post.valid?, 'Post validated whit no date'
    assert_equal post.errors[:date], "can't be nil"
  end

  test "should not validate blog post without title" do
    post  = Post.new(
      source:  @source,
      date:    Date.new,
      authors: [{name: 'Me', email: 'me@mail.com'}]
    )
    assert !post.valid?, 'Post validated whit no title'
    assert_equal post.errors[:title], "can't be nil"
  end

  test "should validate the blog post" do
    post  = Post.new(
      title:   "Hello !",
      source:  @source,
      date:    Date.new,
      authors: [{name: 'Me', email: 'me@mail.com'}]
    )
    assert post.valid?, 'Post not valid but should be !'
  end

  test "should generate html from source in markdown" do
    post = Post.new(
      title:   "Hello !",
      source:  @source,
      date:    Date.new,
      authors: [{name: 'Me', email: 'me@mail.com'}]
    )
    assert_not_nil post.html, 'Markdown not converted into HTML'
  end

  test "should not generate html from unvalid blog post" do
    post = Post.new(
      title:   "Hello !",
      source:  @source,
      authors: [{name: 'Me', email: 'me@mail.com'}]
    )
    assert !post.html, 'Markdown generated from non valid blog post'
  end

  test "should not validate post without at least 1 author" do
    post = Post.new(
      title:  "Hello !",
      source: @source,
      date:   Date.new
    )
    assert !post.valid?, 'Post valid without author'
    assert_equal post.errors[:authors], "can't be empty"
  end

end