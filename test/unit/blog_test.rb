require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  test "should not save blog without name" do
    blog = Blog.new(
      subdomain: 'blog',
      git:       'https://github.com/comit/blog.comit.io.git',
      path:      'blog.comit.io'
    )
    assert !blog.save, "Saved the blog without a name"
  end

  test "should not save blog without subdomain" do
    blog = Blog.new(
      name: 'Comit announces',
      git:  'https://github.com/comit/blog.comit.io.git',
      path: 'blog.comit.io'
    )
    assert !blog.save, "Saved the blog without any subdomain"
  end

  test "should not save blog without git url" do
    blog = Blog.new(
      name:      'Comit announces',
      subdomain: 'blog',
      path:      'blog.comit.io'
    )
    assert !blog.save, "Saved the blog without a git url"
  end

  test "should not save blog without local path" do
    blog = Blog.new(
      name:      'Comit announces',
      subdomain: 'blog',
      git:       'https://github.com/comit/blog.comit.io.git'
    )
    assert !blog.save, "Saved the blog without a local path"
  end

  test "blog subdomain, git url and path must be unique" do
    blog = Blog.new(
      name:      'Test',
      subdomain: 'testing',
      git:       'https://github.com/comit/testing.git',
      path:      'testing'
    )
    assert blog.save, 'Initial blog not saved without any reason'
    another_blog = Blog.new(
      name:      'Test',
      subdomain: 'testing',
      git:       'https://github.com/comit/testing.git',
      path:      'testing'
    )
    assert !another_blog.save, 'Blog saved with duplicated subdomain, git url and path'
    assert_equal another_blog.errors.count, 3, 'Blog saving must had generated 3 errors'
    assert_equal another_blog.errors[:subdomain][0], 'has already been taken'
    assert_equal another_blog.errors[:git][0], 'has already been taken'
    assert_equal another_blog.errors[:path][0], 'has already been taken'
  end

  test "should list all blog post" do
    blog = Blog.find_by_path 'test'
    posts = blog.posts
    assert_not_nil posts[0], 'No post found in the blog repository'
  end

  test "should not list non-correctly named post file" do
    blog = Blog.find_by_path 'test'
    posts = blog.posts
    posts.each do |post|
      assert_not_equal post.title, 'bad name scheme'
    end
  end

  test "should find a post using its filename" do
    blog = Blog.new(
      name:      'Testing',
      subdomain: 'testing',
      git:       'https://github/comit/test.git',
      path:      'test'
    )
    post = blog.find_post '2012-12-05-Welcome_to_Comit.md'
    assert_not_nil post, "No post found"
    assert_equal post.title, 'Welcome to Comit'
  end

  test "should NOT find a post using this filename" do
    blog = Blog.new(
      name:      'Testing',
      subdomain: 'testing',
      git:       'https://github/comit/test.git',
      path:      'test'
    )
    post = blog.find_post 'Welcome_to_Comit'
    assert_nil post, "Post found with random filename"
  end

  test "should refresh a blog directory (git pull origin master)" do
    blog = Blog.find_by_path 'test'
    assert blog.refresh, 'Blog refresh had an error'
  end

  test "should NOT refresh a blog directory (git pull origin master failed)" do
    blog = Blog.find_by_path 'erased'
    assert !blog.refresh, 'Blog refresh had no error but sould do !'
  end  
end