class Adeia::Permission < ActiveRecord::Base
  belongs_to :owner
  belongs_to :element
end
