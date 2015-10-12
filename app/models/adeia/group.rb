class Adeia::Group < ActiveRecord::Base
  has_many :group_users, dependent: :destroy
  has_many :permissions, as: :owner

  validates :name, presence: true
end
