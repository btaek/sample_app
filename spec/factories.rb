# this is to automatically insert users with the below defined attributes
# to the database when the test runs

Factory.define :user do |user|  #factory girl infers from the use of user symbol that we want to create a user class
  user.name                   "Taek Kim"
  user.email                  "btaek@yahoo.com"
  user.password               "foobar"
  user.password_confirmation  "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end