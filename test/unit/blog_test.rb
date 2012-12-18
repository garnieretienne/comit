require 'test_helper'

class BlogTest < ActiveSupport::TestCase

  setup do
    @user = User.first
    @blog = Blog.new(
      name:      "comit-test",
      subdomain: "comit-test",
      git:       "#{Rails.root}/tmp/comit-test",
    )
    @blog.user = @user
  end

  test "should save this blog" do
    assert @blog.save, "Correct blog not saved"
    assert_not_nil @blog.path, "No path gererated"
    assert_not_nil @blog.token, "No token gererated"
  end

  test "should not save a blog with an unreachable git url (domain name unexistant)" do
    blog = Blog.new(
      name:      "comit-test",
      subdomain: "comit-test",
      git:       "git://unknow.dev/repo.git",
    )
    blog.user = @user
    assert !blog.save, "Blog saved with an unreachable git url (domain name unexistant)"
    assert_not_nil @blog.errors[:git], "No errors for the git attribute"
  end

  test "should not save blog without name" do
    @blog.name = nil
    assert !@blog.save, "Saved the blog without a name"
    assert_not_nil @blog.errors[:name], "No errors for the name attribute"
  end

  test "should not save blog without subdomain" do
    @blog.subdomain = nil
    assert !@blog.save, "Saved the blog without any subdomain"
    assert_not_nil @blog.errors[:subdomain], "No errors for the subdomain attribute"
  end

  test "should not save blog without git url" do
    @blog.git = nil
    assert !@blog.save, "Saved the blog without a git url"
    assert_not_nil @blog.errors[:git], "No errors for the git attribute"
  end

  test "should not save blog without owner" do
    @blog.user = nil
    assert !@blog.save, "Saved the blog without any owner"
    assert_not_nil @blog.errors[:user_id], "No errors for the user id attribute"
  end  

  test "blog subdomain, git url must be unique" do
    another_blog = Blog.new(
      name:      "Comit blog",
      subdomain: "blog",
      git:       "https://github.com/comit/blog.comit.io.git"
    )
    assert !another_blog.save, 'Blog saved with duplicated subdomain and git url'
    assert_equal another_blog.errors[:subdomain][0], 'has already been taken'
    assert_equal another_blog.errors[:git][0], 'has already been taken'
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
    blog = Blog.find_by_path 'test'
    post = blog.find_post '2012-12-07-Simple.md'
    assert_not_nil post, "No post found"
    assert_equal post.title, 'Simple'
  end

  test "should NOT find a post using this filename" do
    blog = Blog.find_by_path 'test'
    post = blog.find_post 'Simple'
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

  test "should tell if a blog is ready or not (repo not cloned yet)" do
    blog = Blog.find_by_path 'test'
    assert blog.ready?, "Cloned blog not marked as ready"
  end

end