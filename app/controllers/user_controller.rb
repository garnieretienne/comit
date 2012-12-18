class UserController < ApplicationController

  before_filter :authenticated?
  
  def show
    @user = current_user
    @blog = Blog.new
  end

  def update
    if current_user.update_attributes(params[:user])
      redirect_to user_dashboard_path
    else
      #TODO: manage errors
      redirect_to user_dashboard_path
    end
  end

  def destroy
    current_user.destroy
    session[:user_id] = nil
    redirect_to root_url
  end

end
