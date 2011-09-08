class User < ActiveRecord::Base
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation
  
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  validates :name,    :presence     => true,
                      :length       => { :maximum => 50 }
  validates :email,   :presence     => true,
                      :format       => { :with => email_regex },
                      :uniqueness   => { :case_sensitive => false}
  validates :password,:presence     => true,
                      :confirmation => true,
                      :length       => {:within => 6..40}
  
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  class <<self  # this is a class level definition. here, self refers to the User class, not an instance
    def authenticate(email, submitted_password) #so, as it says above, this is a class level method
      user = find_by_email(email) # this is inside the class methos, no need to be "User.find_by_email"
      return nil if user.nil?
      return user if user.has_password?(submitted_password)
    end
  end
  
  #instead of class level definition as above, following commented out lines can be defined!
  
  #def User.authenticate(email, submitted_password) # note that this is a class method, not an object method   
  #end
  
  private
    def encrypt_password
      self.salt = make_salt if new_record?  #when assigning a value to an attribute of an object, "self."is needed, but when just calling attribute, self.is not needed
      self.encrypted_password = encrypt(password) # above concept explains why it is just password, not self.password. same for the above line's new_record
    end
    
    def encrypt(string)
      secure_hash("#{salt}--#{string}") #the above line's concept explains why it is just salt, not self.salt
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string) #defining a hexa encryption
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

