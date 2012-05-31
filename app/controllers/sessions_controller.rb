class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:session][:username], params[:session][:password])

    if user.nil?
      flash.now[:error] = "Invalid username / password combination"
      render 'new'
    else
      flash[:success] = "You have been successfully signed in."
      sign_in user
      redirect_to user
    end

  end

  def destroy
    flash[:notice] = "You have been successfully signed out."
    sign_out
    redirect_to shows_path
  end
end
