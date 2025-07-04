class SessionsController < ApplicationController
  before_action :require_signin, only: [:destroy]
  before_action :require_logout, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url, notice: "Login successful"
    else
      flash.now.alert = "Invalid username or password"
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_url, notice: "You're now signed out!"
  end
end
