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
      @read_rights ||= Adeia::Permission.joins(:element).where(owner: owners, read_right: true, elements: {name: @controller})
    end

    def create_rights
      @create_rights ||= Adeia::Permission.joins(:element).where(owner: owners, create_right: true, elements: {name: @controller})
    end

    def update_rights
      @update_rights ||= Adeia::Permission.joins(:element).where(owner: owners, update_right: true, elements: {name: @controller})
    end

    def destroy_rights
      @destroy_rights ||= Adeia::Permission.joins(:element).where(owner: owners, destroy_right: true, elements: {name: @controller})
    end

    def action_rights
      @action_rights ||= Adeia::Permission.joins(:actions, :element).where(owner: owners, elements: {name: @controller}, actions: {name: @action})
    end

    def token_rights(right_name)
      @permission_token ||= Adeia::Token.find_by_token(@token)
      if @permission_token && @permission_token.valid
        @token_rights ||= Adeia::Permission.joins(:element).where("ownerships.id = ? AND elements.name = ? AND #{right_name}_right = ?", @permission_token.permission_id, @controller, true)
      else
        @token_rights ||= Adeia::Permission.none
      end
    end

    def user_groups
      @user_groups ||= Adeia::Group.joins(:group_users).where(adeia_group_users: { user_id: @user.id })
    end

    def owners
      @owners ||= user_groups.push @user
    end

  end

end