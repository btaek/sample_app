class UsersController < ApplicationController
  
  before_filter :authenticate ,:only => [:edit, :update]   #only for edit method, authenticate user signedin
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
  
  def new
    @user = User.new
    @title = "Sign up"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to user_path(@user)
    else
      @title = "Sign up"
      @user.password = ""
      @user.password_confirmation = ""
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  private
  
    def authenticate
      deny_access unless signed_in?   # deny_access method is in sessions_helper
    end  
end