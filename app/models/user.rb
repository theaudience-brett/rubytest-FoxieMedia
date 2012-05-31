require 'digest'

class User < ActiveRecord::Base
  include RailsSettings::Extend
  has_many :shows_users
  has_many :shows, :through => :shows_users
  has_many :users_app_configs


  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates_uniqueness_of :username, :case_sensitive => false
  validates :password, :presence => true, :confirmation => true
  validates :email, :presence => true, :format => { :with => email_regex }

  before_save :encrypt_pass

  def get_configs
    @userconfigs = users_app_configs.all
    return @userconfigs
  end

  def has_password?(submitted_pass)
    password == encrypt(submitted_pass)
  end

  def self.authenticate(user, pass)
    user = self.find_by_username(user)
    return nil if user.blank? || user.has_password?(pass) == false
    return user
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    return nil if user.nil? || user.salt != cookie_salt
    return user
  end

  private


  def encrypt_pass
    self.salt = make_salt if new_record?
    self.password = encrypt(password) if new_record? || self.password_changed?
  end

  def encrypt(pass)
    secure_hash("#{salt}--#{pass}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end

  def make_salt
    secure_hash("#{Time.now.utc}--#{password}")
  end

end