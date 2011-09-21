require 'spec_helper'

describe SessionsController do
render_views

  describe "GET 'new'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the right title" do
      get :new #:new symbol could also be ""'new'"" string. default specs use string, but we could use symbos as well!
      response.should have_selector("title", :content => "Sign in")
    end
  end

end