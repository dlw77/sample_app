require 'spec_helper'

describe User do
  before(:each) do
    @attr = {:name=>"Example User", :email=>"user@example.com"}
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
end
