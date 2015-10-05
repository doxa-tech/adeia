module Adeia
  class Action < ActiveRecord::Base
    has_many :action_permissions
    has_many :permissions, through: :action_permissions
  end
end
