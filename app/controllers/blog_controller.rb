class BlogController < ApplicationController

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
