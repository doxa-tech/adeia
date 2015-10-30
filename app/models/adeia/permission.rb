class Adeia::Permission < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :element, foreign_key: :adeia_element_id

  has_many :action_permissions, foreign_key: :adeia_permission_id, dependent: :destroy
  has_many :actions, through: :action_permissions

  enum permission_type: [:all_entries, :on_ownerships, :on_entry]

  accepts_nested_attributes_for :actions, :allow_destroy => true, reject_if: proc { |a| a[:name].blank? }

  validates :owner, presence: true
  validates :element, presence: true
  validates :permission_type, presence: true
  validate :presence_of_resource_id
  validate :presence_of_a_right

  def global_owner
    self.owner.to_global_id if self.owner.present?
  end

  def global_owner=(owner)
    self.owner = GlobalID::Locator.locate owner
  end

  def autosave_associated_records_for_actions
    self.actions = actions.reject{ |a| a._destroy == true }.map do |action|
      Adeia::Action.find_or_create_by(name: action.name)
    end
  end

  def full_name
    "#{id} - #{element.name} - R:#{read_right} - C:#{create_right}- U:#{update_right} - D:#{destroy_right} - #{resource_id} - #{actions.to_a}"
  end

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
