module Adeia
  class Action < ActiveRecord::Base
    has_many :action_permissions, dependent: :destroy
    has_many :permissions, through: :action_permissions

    validates :name, presence: true
  end
end
