require_dependency "adeia/application_controller"

module Adeia
  class PermissionsController < ApplicationController
    load_and_authorize

    def index
      @table = PermissionTable.new(self, @permissions, search: true)
      @table.respond
    end

    def new
      @permission = Permission.new
    end

    def create
      @permission = Permission.new(permission_params)
      if @permission.save
        redirect_to permissions_path, success: t("adeia.permissions.create.success")
      else
        render 'new'
      end
    end

    def edit
    end

    def update
      if @permission.update_attributes(permission_params)
        redirect_to permissions_path, success: t("adeia.permissions.update.success")
      else
        render 'edit'
      end
    end

    def destroy
      @permission.destroy
      redirect_to permissions_path, success: t("adeia.permissions.destroy.success")
    end

    private

    def permission_params
      params.require(:permission).permit(:element_id, :global_owner, :read_right, :create_right, :update_right, :destroy_right, :resource_id, actions_attributes: [:name])
    end

  end
end
