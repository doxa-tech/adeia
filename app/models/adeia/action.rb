module Adeia
  class Action < ActiveRecord::Base
    has_many :action_permissions, foreign_key: :adeia_action_id, dependent: :destroy
    has_many :permissions, through: :action_permissions

    validates :name, presence: true
  end
end
