class UserController < ApplicationController

  before_filter :authenticated?
  
  def show
    @blog = Blog.new
  end

end
