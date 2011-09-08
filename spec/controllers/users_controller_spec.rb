require 'spec_helper'

describe UsersController do
  render_views

  describe "Get 'show'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should be successful" do
      get :show, :id => @user
      # in above line, "":show"" symbol could also be ""'show'"" string. default specs use string, but we could use symbos as well!
      # in above line, ":id => @user" was supposed to be ":id => @user.id", but rails is smart enough to catch the real meaning of ":id => @user"
      response.should be_success
    end
    
    it "should find the right user" do
      get :show, :id => @user
      assigns(:user).should == @user 
      # the above "assigns reaches inside the users_controller and assigns a symbol ':user' is the value of the instance variable '@user'"
    end
    
  end

  describe "GET 'new'" do
    
    it "should be successful" do
      get :new  #:new symbol could also be ""'new'"" string. default specs use string, but we could use symbos as well!
      response.should be_success
    end
    
    it "should have the right title" do
      get :new #:new symbol could also be ""'new'"" string. default specs use string, but we could use symbos as well!
      response.should have_selector("title", :content => "Sign up")
    end
  end

end
