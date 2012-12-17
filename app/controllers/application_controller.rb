class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :current_blog

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_blog
    @current_blog ||= Blog.find_by_subdomain request.subdomain
  end

  def authenticated?
    if !current_user
      redirect_to root_url
    end
  end

  def blog_specified?
    if !current_blog
      redirect_to "http://#{request.domain}#{(request.port ? ":"+request.port.to_s : '')}" and return
    end
  end
end
