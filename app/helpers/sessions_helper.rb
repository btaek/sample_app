module SessionsHelper
  
  def sign_in(user)
  #  cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    # the above is to store user into cookies, so the user is always sign-in even if user closed browser
    session[:user_id] = user.id # this is to auto log out the user when browser closes
    self.current_user = user
  end
  
  def current_user=(user) # setter method
    @current_user = user
  end
  
  def current_user  # getter method
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    # above line replaced the line below to sign-out users when browser cloeses
    # @current_user ||= user_from_remember_token
    # in the above, what ||= does it that it assigns user_from_remember_token to @current_user and return it if @current_user is nil
    # but, if @current_user is true, @current_user gets returned
    
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    # cookies.delete(:remember_token) 
      # above line is to delete cookie, but storing token in cookie is commented out, so is this line
    session[:user_id] = nil
    self.current_user = nil
  end
  
  private
  
  # below two def's are commented out for the case of logging out the user when browser closes
    # def user_from_remember_token
    #   User.authenticate_with_salt(*remember_token)
    #   
    #   # in front of remember_token, there is an asterisk to solve the problem that
    #   # authenticate_with_salt is designed to take in two input variables
    #   # but, here, the method takes in one variable
    #   # what asterisk does is to unwrap one layer of the input variable
    #   # do you see remember_token has actually two values on the top line?
    # end
    # 
    # def remember_token
    #   cookies.signed[:remember_token] || [nil, nil]
    # end
  
end
