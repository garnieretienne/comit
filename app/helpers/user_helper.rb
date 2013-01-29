module UserHelper

  def top_links_for_dashboard
    links = 'Signed in as '
    links += link_to current_user.name, user_dashboard_path
    links += ". "
    links += link_to "Sign out", signout_path
    return links.html_safe
  end
end
