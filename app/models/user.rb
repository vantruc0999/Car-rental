class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # enum role: %i[user admin]
  enum role: { admin: 1, user: 0, moderator: 2 }
  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates_presence_of :email
  validates_uniqueness_of :email, case_sensitive: false
  before_save :downcase_email
  before_create :generate_confirmation_instructions

  has_many :reviews
  has_many :bookings

  # the authenticate method from devise documentation
  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  def downcase_email
    self.email = self.email.delete(' ').downcase
  end
  
  def generate_confirmation_instructions
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.now.utc
  end

  def confirmation_token_valid?
    (self.confirmation_sent_at + 30.days) > Time.now.utc
  end
  
  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
    save
  end

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now.utc
    save!
  end
  
  def password_token_valid?
    (self.reset_password_sent_at + 4.hours) > Time.now.utc
  end
  
  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end
    
  private
  
  def generate_token
    SecureRandom.hex(10)
  end

end
