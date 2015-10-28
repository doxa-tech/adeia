require_dependency "adeia/application_controller"

module Adeia
  class GroupsController < ApplicationController
    load_and_authorize

    def index
      @table = Table.new(self, Adeia::Group, @groups)
      @table.respond
    end

    def new
      @group = Group.new
    end

    def create
      @group = Group.new(group_params)
      if @group.save
        redirect_to groups_path, success: t("adeia.groups.create.success")
      else
        render 'new'
      end
    end

    def edit
    end

    def update
      if @group.update_attributes(group_params)
        redirect_to groups_path, success: t("adeia.groups.update.success")
      else
        render 'edit'
      end
    end

    def destroy
      @group.destroy
      redirect_to groups_path, success: t("adeia.groups.destroy.success")
    end

    private

    def group_params
      params.require(:group).permit(:name)
    end
  end
end
