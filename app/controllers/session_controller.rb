class SessionController < ApplicationController

  before_filter :authenticated?, except: [:create]

  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user
      session[:user_id] = user.id
      redirect_to user_dashboard_url
    else
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
