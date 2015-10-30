module Adeia
  class ActionPermission < ActiveRecord::Base
    belongs_to :action, foreign_key: :adeia_action_id
    belongs_to :permission, foreign_key: :adeia_permission_id
  end
end
