class SessionsController < ApplicationController
  
  def new
    @title = "Sign in"
  end
  
  def create
    user = User.authenticate(params[:session][:email], params[:session][:password])   
    # in the above line, we don't need @user instance variable
    
    if user.nil?
      flash.now[:error] = "Invalid email/password combination." # about ".now", read below
      # here, instead of redirecting the page like signup page's case
      # we only render 'new', so the flash sign will persist for one reuqest
      # in order to make the flash sign disappear when you click on a menu but, I added .now
      # if you are curious, take out "".now"", and click on a menu button to see what     
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_to user # on the left, 'user' is supposed to be 'user_path(user)', but can omit the rest
    end
  end
  
  def destroy
  end

end
