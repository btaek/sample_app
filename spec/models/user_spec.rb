require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { :name => "Example user", 
              :email => "user@exampl.com",
              :password => "foobar",
              :password_confirmation => "foobar"
            }
  end
  
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge( :name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email" do
    no_email_user = User.new(@attr.merge( :email => ""))
    no_email_user.should_not be_valid
  end
  

  it "should reject names that are too long" do
    long_name = "a"*51
    long_name_user = User.new(@attr.merge( :name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    address = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.kr]
    address.each do |address|
      valid_email_user = User.new(@attr.merge( :email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    address = %w[user@foo,com THE_USER_foo.bar.org first.last@foo.]
    address.each do |address|
      invalid_email_user = User.new(@attr.merge( :email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email address identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "passwords" do
    
    before(:each) do
      @user = User.new(@attr)
    end
    
    it "should have a password attribute" do
      @user.should respond_to(:password)
    end
    
    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confimation => "")).should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a"*5
      hash = @attr.merge(:password => short, :pasword_confimation => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a"*41
      hash = @attr.merge(:password => long, :pasword_confimation => long)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "passwords encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
  end
end


# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#

