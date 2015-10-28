require_dependency "adeia/application_controller"

module Adeia
  class GroupsController < ApplicationController
    load_and_authorize

    def index
      @table = Table.new(self, Adeia::Group, @groups)
      @table.respond
    end

  end
end
