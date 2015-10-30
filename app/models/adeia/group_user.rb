class Adeia::GroupUser < ActiveRecord::Base
  belongs_to :group, foreign_key: :adeia_group_id
  belongs_to :user
end
