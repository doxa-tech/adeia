class Adeia::Element < ActiveRecord::Base
  has_many :permissions

  validates :name, presence: true
end
