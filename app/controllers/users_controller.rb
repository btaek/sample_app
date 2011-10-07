class UsersController < ApplicationController
  
  before_filter :authenticate ,   :only => [:index, :edit, :update, :destroy]   #only for edit method, authenticate user signedin
  before_filter :correct_user,    :only => [:edit, :update]
  before_filter :admin_user,      :only => [:destroy]
  before_filter :check_signed_in, :only => [:new, :create]  # don't allow new and create for signed in users
  
  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
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
    # above line can be deleted because it exists in admin_user, 
    # and admin_user is called in before_filter, so the above line executed already at the beginning
    @title = "Edit user"
  end
  
  def update
    @user = User.find(params[:id])
    # above line can be deleted because it exists in admin_user, 
    # and admin_user is called in before_filter, so the above line executed already at the beginning
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end
  
  def destroy
      @user.destroy
      # User.find(params[:id]).destroy  # above line replaced this line
      flash[:success] = "User destroyed"
      redirect_to users_path
    end
  
  private
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)  # current_user? is in sessions helper
    end
    
    def admin_user
      @user = User.find(params[:id])
      redirect_to(root_path) if (!current_user.admin? || current_user?(@user))
    end
    
    def check_signed_in
      redirect_to root_path if signed_in? # redirect to the root_path if the user is signed in
    end
end