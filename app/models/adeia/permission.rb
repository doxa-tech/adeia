class Adeia::Permission < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :element

  has_many :action_permissions, dependent: :destroy
  has_many :actions, through: :action_permissions

  enum permission_type: [:all_entries, :on_ownerships, :on_entry]

  validates :owner, presence: true
  validates :element, presence: true
  validates :permission_type, presence: true
  validate :presence_of_resource_id
  validate :presence_of_a_right

  private

  def presence_of_resource_id
    if permission_type == "on_entry" && resource_id.nil?
      errors.add(:resource_id, I18n.t("errors.messages.blank"))
    end
  end

  def presence_of_a_right
    if permission_type == "on_ownerships" && !(read_right || update_right || destroy_right || actions.any?)
      errors[:base] << I18n.t("errors.messages.right_required")
    end
  end

end
