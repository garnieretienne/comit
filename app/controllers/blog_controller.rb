class BlogController < ApplicationController
  def index
    if current_blog
      show
      render action: :show
    else
      all
      render action: :all
    end
  end

  def all
    @blogs = Blog.all
  end

  def show
    @blog  = current_blog
    @posts = @blog.posts
  end
end
