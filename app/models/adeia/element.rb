class Adeia::Element < ActiveRecord::Base
  has_many :permissions, foreign_key: :adeia_element_id

  validates :name, presence: true
end
