module Adeia
  class Token < ActiveRecord::Base
    belongs_to :permission, foreign_key: :adeia_permission_id

    validates :permission, presence: true
    validates :exp_at, presence: true

    before_create :generate_token

    def is_valid?
      exp_at > Time.now && is_valid
    end

    private

    def generate_token
      self.token = SecureRandom.urlsafe_base64
    end
    
  end
end
