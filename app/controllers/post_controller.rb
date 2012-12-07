class PostController < ApplicationController
  
  def show
    @blog = current_blog
    post_filename = "#{params[:year]}-#{params[:month]}-#{params[:day]}-#{params[:title]}.md"
    @post = @blog.find_post post_filename
    if !@post
      redirect_to root_path
    end
  end

  def markdown
    @blog = current_blog
    post_filename = "#{params[:year]}-#{params[:month]}-#{params[:day]}-#{params[:title]}.md"
    @post = @blog.find_post post_filename
    if !@post
      redirect_to root_path
    end
    render text: @post.source, content_type: 'text/plain'
  end

end
