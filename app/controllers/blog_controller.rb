class BlogController < ApplicationController

  before_filter :authenticated?, except: [:index, :all, :show, :hook]

  # Root URL
  def index

    # Display blog
    if current_blog
      render :not_ready and return if !current_blog.ready? # Repository is not cloned yet
      show
      render action: :show and return
      
    # Blog do not exist, redirect to welcome page
    elsif request.subdomain != ""
      redirect_to "http://#{request.domain}#{if request.port then ":"+request.port.to_s end}" and return

    # Welcome page
    else
      all
      render action: :all and return
    end

  end

  def all
    @blogs = Blog.all
  end

  def show
    @posts = current_blog.posts
  end

  # Hook URL used to refresh a repo on demand
  def hook
    if current_blog
      if current_blog.ready? # Repository is already cloned
        if params[:token] == current_blog.token
          if current_blog.refresh
            render nothing: true, status: 200
            return
          end
        end
      end
    end
    render nothing: true, status: 404
  end

  def create
    @blog = Blog.new(params[:blog])
    @blog.user = current_user
    if @blog.save
      redirect_to user_dashboard_path
    else
      @display_blog_form = 'display-blog-form'
      @user = current_user
      render 'user/show'
    end
  end

  def edit
    @blog = current_user.blogs.find(params[:id])
    @user = current_user
    @display_blog_form = 'display-blog-form'
    render 'user/show'
  end

  def update
    @blog = current_user.blogs.find(params[:id])
    git  = @blog.git
    path = @blog.path
    if @blog.update_attributes(params[:blog])
      redirect_to user_dashboard_path
    else
      @display_form = 'display-form'
      render 'user/show'
    end
  end

  def destroy
    @blog = current_user.blogs.find(params[:id])
    path = @blog.path
    @blog.destroy
    redirect_to user_dashboard_path
  end

end
