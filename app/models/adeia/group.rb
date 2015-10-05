class Adeia::Group < ActiveRecord::Base
  has_many :group_users
  has_many :permissions, as: :owner
end
