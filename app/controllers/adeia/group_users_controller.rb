require_dependency "adeia/application_controller"

module Adeia
  class GroupUsersController < ApplicationController
    load_and_authorize

    def index
      @table = GroupUserTable.new(self, @group_users)
      @table.respond
    end

    def new
      @group_user = GroupUser.new
    end

    def create
      @group_user = GroupUser.new(group_user_params)
      if @group_user.save
        redirect_to group_users_path, success: t("adeia.group_users.create.success")
      else
        render 'new'
      end
    end

    def edit
    end

    def update
      if @group_user.update_attributes(group_user_params)
        redirect_to group_users_path, success: t("adeia.group_users.update.success")
      else
        render 'edit'
      end
    end

    def destroy
      @group_user.destroy
      redirect_to group_users_path, success: t("adeia.group_users.destroy.success")
    end

    private

    def group_user_params
      params.require(:group_user).permit(:user_id, :adeia_group_id)
    end
  end
end
