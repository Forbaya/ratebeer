class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by username: params[:username]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!"
    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end
  end

  def create_oauth
    username = env["omniauth.auth"].info.nickname
    if (User.find_by username:username).nil? then
      user = User.new
      user.skip_password_validation = true
      password = (0...8).map { (65 + rand(26)).chr }.join
      user.username = username
      user.password = password
      user.password_confirmation = password
      user.admin = false
      user.banned = false
      user.save
      
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Logged in with Github"
    else
      user = User.find_by username:username
      session[:user_id] = user.id
      redirect_to user_path(user), notice: "Welcome back"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
