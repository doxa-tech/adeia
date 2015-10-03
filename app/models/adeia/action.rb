module Adeia
  class Action < ActiveRecord::Base
    has_many :action_permissions
  end
end
