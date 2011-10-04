require 'spec_helper'

describe UsersController do
  render_views
  
  describe "Get 'index'" do
    
    describe "for non-signied-in user" do
      it "should deny access" do
        get :index
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in-users" do
      
      before(:each) do
        @user = test_sign_in(Factory(:user))  # this one line is the same as the two commented lines below
        # @user = Factory(:user)
        # test_sign_in(@user)
        Factory(:user, :email => "another@example.com")
        Factory(:user, :email => "another@example.net")
        
        30.times do
          Factory(:user, :email => Factory.next(:email))
        end
      end
      
      it "should be successful" do
        get :index
        response.should be_success
      end
      
      it "should have the right title" do
        get :index
        response.should have_selector('title', :content => "All users")
      end
      
      it "should have an element for each user" do
        get :index
        User.all.paginate(:page => 1).each do |user|
          response.should have_selector('li', :content => user.name)
        end
      end
      
      it "should paginate users" do
        get :index
        response.should have_selector('div.pagination')
        response.should have_selector('span.disabled', :content => "Previous")
        response.should have_selector('a', :href => "/users?page=2", :content => "2")
        response.should have_selector('a', :href => "/users?page=2", :content => "Next")
      end
      
      it "should have delete links for admins" do
        @user.toggle!(:admin)
        other_user = User.all.second
        get :index
        response.should have_selector('a', :href => user_path(other_user), :content => "delete")
        # in the above, user_path(other_user) replaced "/user/#{other_user.id}" w/ quotation mark
      end
      
      it "should not have delete links for non admins" do
        other_user = User.all.second
        get :index
        response.should_not have_selector('a', :href => user_path(other_user), :content => "delete")
      end
    end 
  end

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
    
    describe "for signed-in users" do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      it "should redirect to the root_path" do
        get :new
        response.should redirect_to(root_path)
      end
    end
    
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
    
    describe "for signed-in users" do
       
       before(:each) do
         @user = Factory(:user)
         test_sign_in(@user)
         @attr = { :name => "New User", :email => "user@example.com", :password => "foobar", :password_confirmation => "foobar"}
       end
       
       it "should redirect to the root_path" do
         post :create, :user => @attr
         response.should redirect_to(root_path)
       end
     end
    
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
  
  describe "Get 'edit'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    it "should be successful" do
      get :edit, :id => @user
      response.should be_success
    end
    
    it "should have the right title" do
      get :edit, :id => @user
      response.should have_selector('title', :content => "Edit user")
    end
    
    it "should have a link to change the Gravatar" do
      get :edit, :id => @user
      response.should have_selector('a', :href => 'http://gravatar.com/emails',
                                          :content => "change")
    end   
  end
  
  describe "PUT 'upate'" do
    
    before(:each) do
      @user = Factory(:user)
      test_sign_in(@user)
    end
    
    describe "failure" do

        before(:each) do
          @attr = {:name => "", :email => "", :password => "", :password_confirmation => ""}
        end
        
        it "should render the edit page" do
          put :update, :id => @user, :user => @attr
          response.should render_template('edit')
        end
        
        it "should have the right title" do
          put :update, :id => @user, :user => @attr
          response.should have_selector('title', :content => "Edit user")
        end
    end
    
    describe "success" do
      
      before(:each) do
        @attr = { :name => "New Name", :email => "btaek@hotmail.com", 
                  :password => "barbaz", :password_confirmation => "barbaz"}
      end
      
      it "should change the user's attributes" do
        put :update, :id => @user, :user => @attr
        user = assigns(:user)
        @user.reload
        @user.name.should == user.name
        @user.email.should == user.email
        @user.encrypted_password.should == user.encrypted_password
      end
      
      it "should have a flash message" do
        put :update, :id => @user, :user => @attr
        flash[:success].should =~ /updated/
      end
    end
  end
  
  describe "authentication of edit/update actions" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "for non-signed-in users" do
      it "should deny access to 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(signin_path)
        flash[:notice].should =~ /sign in/i
      end

      it "should deny access to 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(signin_path)
      end
    end
    
    describe "for signed-in users" do
      
      before(:each) do
        wrong_user = Factory(:user, :email => "user@example.net")
        test_sign_in(wrong_user)
      end
      
      it "should require matching users for 'edit'" do
        get :edit, :id => @user
        response.should redirect_to(root_path)
      end
      
      it "should require matching users for 'update'" do
        put :update, :id => @user, :user => {}
        response.should redirect_to(root_path)
      end
    end    
  end
  
  describe "DELETE 'destroy'" do
    
    before(:each) do
      @user = Factory(:user)
    end
    
    describe "as a non-signed-in user" do
      
      it "should deny access" do
        delete :destroy, :id => @user
        response.should redirect_to(signin_path)
      end
    end
    
    describe "as a non-admin user" do
      
      it "should protect the action" do
        test_sign_in(@user)
        delete :destroy, :id => @user
        response.should redirect_to(root_path)
      end
      
      it "should have show delete links for non-admin user" do
        test_sign_in(@user)
        other_user = User.all.second
        delete :destroy, :id => @user
        response.should_not have_selector('a', :href => user_path(other_user), :content => "delete")
      end
    end
    
    describe "as an admin user" do
      
      before(:each) do
        @admin = Factory(:user, :email => "admin@example.com", :admin => true)
        # normally, you cannot set :admit => true because it is not in attr_accessible
        # but, Factory bipasses that. interesting!!!
        test_sign_in(@admin)
      end
      
      it "should destroy the user" do
        lambda do
          delete :destroy, :id => @user
        end.should change(User, :count).by(-1)
      end
      
      it "should redirect to the users page" do
        delete :destroy, :id => @user
        flash[:success].should =~ /User destroyed/i
        response.should redirect_to(users_path)
      end
      
      it "should not be able to destroy itself" do
        lambda do
          delete :destroy, :id => @admin
        end.should_not change(User, :count)
      end
    end
  end
end