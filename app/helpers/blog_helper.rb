module BlogHelper
  def path_to_blog_post(post)
    return "/#{post.date.strftime("%Y/%m/%d")}/#{post.title.gsub /\s/, '_'}"
  end
end
