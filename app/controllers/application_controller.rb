class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include SessionsHelper
  
  # the above line is a very interesting line becasue...
  # methods defined in sessions_helper.rb cannot be recognized by sessions_controller.rb
  # so, by including the line above, sessions_controller.rb can now recognizes methods in sessions_helper.rb
  
end
