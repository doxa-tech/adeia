class Adeia::Permission < ActiveRecord::Base
  belongs_to :owner, polymorphic: true
  belongs_to :element

  has_many :action_permissions
  has_many :actions, through: :action_permissions

  enum permission_type: [:all_entries, :on_ownerships, :on_entry]
end
