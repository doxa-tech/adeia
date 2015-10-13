require 'adeia/controller_resource'

module Adeia

  module ControllerMethods

    module ClassMethods

      def load_and_authorize(**args)
        ControllerResource.add_before_filter(self, :load_resource_or_records_and_authorize, **args)
      end

    end

    def self.included(base)
      base.extend ClassMethods
      base.helper_method :can?
    end

    def load_and_authorize!(**args)
      controller_resource = ControllerResource.new(self, **args)
      resource = controller_resource.load_resource
      controller_resource.authorize!
      return resource
    end

    def authorize_and_load_records!(**args)
      controller_resource = ControllerResource.new(self, **args)
      controller_resource.check_permissions!
      return controller_resource.load_records
    end

    def authorize!(**args)
      ControllerResource.new(self, **args).authorize!
    end

    def can?(action, controller=nil, resource=nil)
      args = { action: action, controller: controller, resource: resource }
      ControllerResource.new(self, **args).can?
    end
  end

end