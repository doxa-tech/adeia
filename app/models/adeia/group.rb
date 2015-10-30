class Adeia::Group < ActiveRecord::Base
  has_many :group_users, foreign_key: :adeia_group_id, dependent: :destroy
  has_many :permissions, as: :owner

  validates :name, presence: true

  def self.human_name
    model_name.i18n_key
  end
end
