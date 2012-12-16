class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def current_blog
    @current_blog ||= Blog.find_by_subdomain request.subdomain
  end
  helper_method :current_blog

  def url_for_subdomain(subdomain)
    if request.port
      return "http://#{subdomain}.#{request.domain}:#{request.port}"
    else
      return "http://#{subdomain}.#{request.domain}"
    end
  end
  helper_method :url_for_subdomain

  def url_for_token(token)
    if request.port
      return "http://#{request.domain}:#{request.port}/hook/#{token}"
    else
      return "http://#{request.domain}/hook/#{token}"
    end
  end
  helper_method :url_for_token

  def path_to_blog_post(post)
    return "/#{post.date.strftime("%Y/%m/%d")}/#{post.title.gsub /\s/, '_'}"
  end
  helper_method :path_to_blog_post
end
