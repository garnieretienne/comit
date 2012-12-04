class ApplicationController < ActionController::Base
  protect_from_forgery

  def current_blog
    Blog.find_by_subdomain request.subdomain
  end

  def url_for_subdomain(subdomain)
    if request.port
      return "http://#{subdomain}.#{request.domain}:#{request.port}"
    else
      return "http://#{subdomain}.#{request.domain}"
    end
  end
  helper_method :url_for_subdomain
end
