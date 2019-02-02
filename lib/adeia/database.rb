module Adeia

  class Database

    def initialize(controller, action, token, resource, user)
      @controller = controller
      @action = action
      @token = token
      @resource = resource
      @user = user
    end

    def read_rights
      @read_rights ||= Adeia::Permission.joins(:element).where(owner: owners, read_right: true, adeia_elements: {name: @controller})
      @read_resource_ids ||= @read_rights.pluck(:resource_id).compact
      return { rights: @read_rights, resource_ids: @read_resource_ids }
    end

    def create_rights
      @create_rights ||= Adeia::Permission.joins(:element).where(owner: owners, create_right: true, adeia_elements: {name: @controller})
      return { rights: @create_rights }
    end

    def update_rights
      @update_rights ||= Adeia::Permission.joins(:element).where(owner: owners, update_right: true, adeia_elements: {name: @controller})
      @update_resource_ids ||= @update_rights.pluck(:resource_id).compact
      return { rights: @update_rights, resource_ids: @update_resource_ids }
    end

    def destroy_rights
      @destroy_rights ||= Adeia::Permission.joins(:element).where(owner: owners, destroy_right: true, adeia_elements: {name: @controller})
      @destroy_resource_ids ||= @destroy_rights.pluck(:resource_id).compact
      return { rights: @destroy_rights, resource_ids: @destroy_resource_ids }
    end

    def action_rights
      @action_rights ||= Adeia::Permission.joins(:actions, :element).where(owner: owners, adeia_elements: {name: @controller}, adeia_actions: {name: @action})
      @action_resource_ids ||= @action_rights.pluck(:resource_id).compact
      return { rights: @action_rights, resource_ids: @action_resource_ids }
    end

    def token_rights(right_name)
      @permission_token ||= Adeia::Token.find_by(token: @token)
      if @permission_token && @permission_token.is_valid?
        @token_rights ||= Adeia::Permission.joins(:element).where(id: @permission_token.adeia_permission_id, adeia_elements: { name: @controller }, "#{right_name}_right": true)
        @token_resource_ids ||= @token_rights.pluck(:resource_id).compact
        return { rights: @token_rights, resource_ids: @token_resource_ids }
      else
        return { rights: Adeia::Permission.none }
      end
    end

    def user_groups
      if @user_groups.nil?
        @user_groups = []
        @user_groups = Adeia::Group.joins(:group_users).where(adeia_group_users: { user_id: @user.id }).to_a if @user
      end
      return @user_groups
    end

    def owners
      if @owners.nil?
        @owners = user_groups
        @owners = user_groups.push @user if @user
      end
      return @owners
    end

  end

end
