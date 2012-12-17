module ApplicationHelper

  def url_for_subdomain(subdomain)
    return "http://#{subdomain}.#{request.domain}#{(request.port ? ":"+request.port.to_s : "")}"
  end

  def url_for_token(token)
    return "http://#{request.domain}#{(request.port) ? ':'+request.port.to_s : ''}/hook/#{token}"
  end
end
