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
    
    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector('title', :content => @user.name)
    end
    
    it "should have the user's name" do
      get :show, :id => @user
      response.should have_selector('h1', :content => @user.name)
    end
    
    it "should have a profile image" do
      get :show, :id => @user
      response.should have_selector('h1>img', :class => "gravatar") #'h1>img' means img tag is inside h1 tag
    end
    
    it "should have the right URL" do
      get :show, :id => @user
      response.should have_selector('td>a', :content => user_path(@user),
                                            :href    => user_path(@user))
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
    
    it "should have a name field" do
      get :new
      response.should have_selector("input[name='user[name]'][type='text']")
    end
    
    it "should have an email field" do
      get :new
      response.should have_selector("input[name='user[email]'][type='text']")
    end
    
    it "should have a password field" do
      get :new
      response.should have_selector("input[name='user[password]'][type='password']")
    end
    
    it "should have a name password confirmation" do
      get :new
      response.should have_selector("input[name='user[password_confirmation]'][type='password']")
    end
  end
  
  describe "POST 'create'" do
    
    describe "failure" do
      
      before(:each) do
        @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
      end
      
      it "should have the right title" do
        post :create, :user => @attr
        response.should have_selector('title', :content => "Sign up")
      end
      
      it "should render the 'new' page" do
        post :create, :user => @attr
        response.should render_template('new')
      end
      
      it "should not create a user" do
        lambda do
          post :create, :user => @attr
        end.should_not change(User, :count)
      end
      
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"}
      end
      
      it "should create a user" do
        lambda do
          post :create, :user => @attr
        end.should change(User, :count).by(1)
      end
      
      it "should redirect to the user show page" do
        post :create, :user => @attr
        response.should redirect_to(user_path(assigns(:user)))
      end
      
      it "should have a welcome message" do
        post :create, :user => @attr
        flash[:success].should =~ /welcome to the sample app/i
      end
      
      it "should sign in a user" do
        post :create, :user => @attr
        controller.should be_signed_in
      end
    end
  end
end