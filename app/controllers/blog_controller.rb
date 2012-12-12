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

  # Hook URL used to refresh a repo on demand
  def hook
    if current_blog
      if params[:token] == current_blog.token
        if current_blog.refresh
          render nothing: true, status: 200
          return
        end
      end
    end
    render nothing: true, status: 404
  end

end
