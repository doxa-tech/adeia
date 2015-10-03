module Adeia
  class Token < ActiveRecord::Base
    belongs_to :permission
  end
end
