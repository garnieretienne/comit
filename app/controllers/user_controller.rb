class UserController < ApplicationController

  before_filter :authenticated?
  
  def show
    @blog = Blog.new
  end

  protected

  def authenticated?
    if !current_user
      redirect_to root_url
    end
  end

end
