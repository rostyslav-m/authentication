class User < ActiveRecord::Base
  
#  attr_accessible :email, :password, :password_confirmation
  
  attr_accessor :password

  before_save :encrypt_password
  
  validates_confirmation_of :password

  validates :password, presence: true,
            format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}\z/,
            message: "must be at least 8 characters and include one number one lowercase and uppercase letters" }

  validates :name, uniqueness: true,
            format: { with: /\A[A-Za-z]+\ [A-Za-z]+\z/,
            message: "only two words and allows letters with a space" }

  validates :username, presence: true,
            uniqueness: true

  validates :phone, format: { with: /\A\+?(380(\d{9}))|(7(\d{10}))\z/,
            message: "use format +7XXXXXXXXXX or +380XXXXXXXXX" }

  validates :email, presence: true,
            uniqueness: true,
            length: {:minimum => 5, :maximum => 254},
            format: { with: /@/,
            message: "is not email format" }

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end

end
