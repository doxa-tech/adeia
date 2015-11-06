require 'adeia/controller_resource'
require 'adeia/exceptions'

module Adeia

  module ControllerMethods

    module ClassMethods

      def load_and_authorize(**args)
        ControllerResource.add_before_filter(self, :load_resource_or_records_and_authorize, **args)
      end

      def require_login(**args)
        ControllerResource.add_before_filter(self, :require_login, **args)
      end

    end

    def self.included(base)
      base.extend ClassMethods
      base.helper_method :can?, :rights?
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

    def require_login!
      raise LoginRequired unless signed_in?
    end

    def can?(action, element, resource=nil)
      ControllerResource.new(self, action: action).authorized?(:can?, element, resource)
    end

    def rights?(action, element, resource=nil)
      ControllerResource.new(self, action: action).authorized?(:rights?, element, resource)
    end

    # Redirect the user to the stored url or the default one provided
    # 
    # * *Args*    :
    #   - default path to redirect to
    # * *Returns* :
    #
    def redirect_back_or(default, message = nil)
      redirect_to(cookies[:return_to] || default, message)
      cookies.delete(:return_to)
    end

  end

end