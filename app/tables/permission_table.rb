class PermissionTable < BaseTable

  def model
    Adeia::Permission
  end

  def attributes
    [:id, :permission_type, { element: :name }, { owner: :name }, :read_right, :create_right, :update_right, :destroy_right, :resource_id, :actions, :created_at, :updated_at]
  end

  module Search

    def self.associations
      [:element]
    end

    def self.fields
      { adeia_elements: [:name] }
    end
  end

end