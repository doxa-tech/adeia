require_dependency "adeia/application_controller"

module Adeia
  class PermissionsController < ApplicationController

    def index
      authorize_and_load_records!
      @table = PermissionTable.new(self, @permissions, search: true)
      @table.respond
    end

  end
end
