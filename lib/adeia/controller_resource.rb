require 'adeia/authorization'
require 'adeia/exceptions'

module Adeia

  class ControllerResource

    def self.add_before_filter(controller_class, method, **args)
      controller_class.send(:before_action, args.slice(:only, :except, :if, :unless)) do |controller|
        ControllerResource.send(method, controller)
      end
    end

    def self.load_resource_or_records_and_authorize(controller)
      if controller.action_name == "index"
        controller.authorize_and_load_records!
      else
        controller.load_and_authorize!
      end
    end

    def initialize(controller, **args)
      @controller = controller
      @action_name = args.fetch(:action, @controller.action_name)
      @controller_name = args.fetch(:controller, @controller.controller_path)
      @token = args.fetch(:token, @controller.params[:token])
      @resource = args[:resource]
      @user = @controller.current_user
    end

    def load_resource
      begin
        @resource = resource_class.find(@controller.params.fetch(:id))
        @controller.instance_variable_set("@#{resource_name}", @resource)
      rescue KeyError
        raise MissingParams.new(:id)
      end
    end

    def load_records
      rights = authorization.read_rights.merge(authorization.token_rights(:read)) { |key, v1, v2| v1 + v2 }
      rights, resource_ids = rights[:rights], rights[:resource_ids]
      @records ||= if rights.any? { |r| r.permission_type == "all_entries" }
        resource_class.all
      elsif rights.any? { |r| r.permission_type == "on_ownerships" }
        resource_class.where("user_id = ? OR id IN (?)", @user.id, resource_ids)
      elsif rights.any? { |r| r.permission_type == "on_entry" }
        resource_class.where(id: resource_ids)
      else
        resource_class.none
      end
      @controller.instance_variable_set("@#{resource_name.pluralize}", @records)
    end

    def authorization
      @authorization ||= Authorization.new(@controller_name, @action_name, @token, @resource, @user)
    end

    def authorize!
      authorization.authorize!
    end

    def check_permissions!
      authorization.check_permissions!
    end

    def can?
      authorization.can?
    end

    private

    def resource_class
      begin
        @controller.controller_path.classify.constantize
      rescue NameError
        @controller.controller_name.classify.constantize
      end
    end

    def resource_name
      resource_class.model_name.element
    end

  end

end