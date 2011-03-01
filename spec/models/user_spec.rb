require 'spec_helper'

describe User do
  before(:each) do
    @attr = {
        :name=>"Example User", 
        :email=>"user@example.com",
        :password=>"foobar",
        :password_confirmation=>"foobar"}
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name=>""))
    no_name_user.should_not be_valid
    # Alternate version 
    #    @attr[:name]=""
    #    no_name_user = User.new(@attr)
    #    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email=>""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    # Simple version
    #long_name = "x" * 51
    #long_name_user = User.new(@attr.merge(:name=>long_name))
    #long_name_user.should_not be_valid
    # Alternate Version
    User.new(@attr.merge(:name=>("x"*51))).should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.net]
    addresses.each do |test_email|
      User.new(@attr.merge(:email=>test_email)).should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com THE_USER_at_foo.bar.org first.last@foo.net.]
    addresses.each do |test_email|
      User.new(@attr.merge(:email=>test_email)).should_not be_valid
    end
  end

  it "should reject duplicate email addresses" do
    User.create!(@attr)
    User.new(@attr).should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    User.create!(@attr.merge(:email=>(@attr[:email].upcase)))
    User.new(@attr).should_not be_valid
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  describe "password validations" do
    it "should require a password" do
      User.new(@attr.merge(
        :password=>"",
        :password_confirmation=>"")).
        should_not be_valid
    end
    
    it "should require a matching password confirmation" do
      User.new(@attr.merge(
        :password_confirmation=>"invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      pwd_length = 5
      User.new(@attr.merge(
        :password=>"x"*pwd_length, 
        :password_confirmation=>"x"*pwd_length)).
        should_not be_valid
    end
    
    it "should reject long passwors" do
      pwd_length = 41
      User.new(@attr.merge(
        :password=>"x"*pwd_length, 
        :password_confirmation=>"x"*pwd_length)).
        should_not be_valid
    end
            
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do

      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should be false if the passwords don't match" do
        @user.has_password?("badone").should be_false
      end
      
    end

    describe "authenticate method" do
      
      it "should return nil on email/password mismatch" do
        User.authenticate(@attr[:email],"wrongpass").should be_nil
      end
      
      it "should return nil for an email address with no user" do
        User.authenticate("foo@bar.com", @attr[:password]).should be_nil
      end
      
      it "should return the user on email/password match" do
        @user.should == User.authenticate(@attr[:email], @attr[:password])
      end
      
    end
  end
  
end
