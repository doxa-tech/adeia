class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by_name(params[:session][:name])
    if @user && @user.authenticate(params[:session][:password])
      sign_in(@user, permanent: params[:session][:remember_me] == "1")
      redirect_to articles_path, success: "Signed in"
    else
      flash.now[:error] = "Incorrect user/password"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_path, "Signed out"
  end

end
