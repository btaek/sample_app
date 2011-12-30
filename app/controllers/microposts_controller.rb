class MicropostsController < ApplicationController
  
  before_filter :authenticate, :only => [:create, :destroy]
  before_filter :authorized_user, :only => :destroy
  
  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      redirect_to root_path, :flash => { :success => "Micropost created!"}
    else
      @feed_items = []
      render 'pages/home'
    end
  end
  
  def destroy
    @micropost.destroy
    redirect_back_or root_path  # this line replaced the libe below
    # redirect_to root_path, :flash => { :success => "Micropost deleted!"}
  end
  
  private
  
    def authorized_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_path if @micropost.nil? # this line and the line above replaced two lines below
      # @micropost = Micropost.find(params[:id])
      # redirect_to root_path unless current_user?(@micropost.user)
    end
  
end