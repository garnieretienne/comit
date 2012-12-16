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

  def create
    @blog = Blog.new(params[:blog])
    @blog.user = current_user
    @blog.path = File.basename(params[:blog][:git]) if params[:blog][:git]
    if @blog.save
      redirect_to user_dashboard_path
    else
      @display_form = 'display-form'
      render 'user/show'
    end
  end

end
