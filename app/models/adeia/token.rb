module Adeia
  class Token < ActiveRecord::Base
    belongs_to :permission

    validates :permission_id, presence: true
    validates :exp_at, presence: true

    before_create :generate_token

    private

    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end
    
  end
end
