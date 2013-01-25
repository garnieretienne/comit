module ApplicationHelper

  def url_for_subdomain(subdomain)
    return "http://#{subdomain}.#{request.domain}#{(request.port ? ":"+request.port.to_s : "")}"
  end

  def url_for_token(token)
    return "http://#{request.domain}#{(request.port) ? ':'+request.port.to_s : ''}/hook/#{token}"
  end

  # https://gist.github.com/989218
  def gravatar_image_tag(email,*args)    
    opts = args.extract_options!
    opts[:class]||=""
    opts[:class]+=" gravatar"
    size = opts.delete(:size) || 80
    require 'digest/md5'
    
    default=""
    if opts[:default]
      require 'cgi'
      default= "&d=#{CGI::escape(opts.delete(:default))}"
    end
    hash = Digest::MD5.hexdigest(email.downcase)    
    img= image_tag "http://www.gravatar.com/avatar/#{hash}?size=#{size}#{default}", opts
    if opts[:profile]
      opts.delete(:profile)
      link_to img,"http://www.gravatar.com/#{hash}",opts
    else
      img
    end
  end

  # generate a div containing the avatar url
  def gravatar_div_tag(email, *args)
  	opts = args.extract_options!
  	size = opts.delete(:size) || 80
  	hash = Digest::MD5.hexdigest(email.downcase)
  	div = "<div class='avatar' data-gravatar='http://www.gravatar.com/avatar/#{hash}?size=#{size}&d=404'></div>".html_safe
  end
end
