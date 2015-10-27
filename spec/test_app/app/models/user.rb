class User < ActiveRecord::Base
  has_many :articles

  has_secure_password

  before_save :create_remember_token

  def self.human_name
    model_name.human
  end

  private

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
