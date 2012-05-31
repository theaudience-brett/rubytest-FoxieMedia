class UsersController < ApplicationController
  # GET /shows
  # GET /shows.json
  #def index
  #
  #  respond_to do |format|
  #    if current_user
  #      format.html { render action: "login" }
  #    end
  #    format.html # index.html.erb
  #  end
  #end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def register
    @user = User.new

    respond_to do |format|
      format.html
    end
  end

  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        sign_in @user
        flash[:success] = "Your account has been created and you have been logged in."
        format.html { redirect_to @user }
      else
        format.html { render action: "register"}
      end
    end
  end


end
