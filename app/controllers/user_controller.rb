class UserController < ApplicationController

  before_filter :authenticated?
  
  def show
    @user = current_user
  end

  protected

  def authenticated?
    if !current_user
      redirect_to root_url
    end
  end

end
