module Adeia
  class ActionPermission < ActiveRecord::Base
    belongs_to :action
    belongs_to :permission
  end
end
