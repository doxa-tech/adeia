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
      case controller.action_name
      when "index"
        controller.authorize_and_load_records!
      when "show", "edit", "update", "destroy"
        controller.load_and_authorize!
      else
        controller.authorize!
      end
    end

    def self.require_login(controller)
      controller.require_login!
    end

    def initialize(controller, **args)
      @controller = controller
      @action_name = args.fetch(:action, @controller.action_name)
      @controller_name = args.fetch(:controller, @controller.controller_path)
      @token = args.fetch(:token, @controller.request.GET[:token])
      @resource = args[:resource]
      @user = @controller.current_user
      @controller.current_user ||= User.new # if not signed in but authorized
      @controller.store_location
    end

    def load_resource
      begin
        @resource ||= resource_class.find(@controller.params.fetch(:id))
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

    def authorized?(method, element, resource)
      @controller_name, @resource = get_controller_and_resource(element, resource)
      instance_variable_get_or_set(method)
    end

    private

    def resource_class
      begin
        @controller_name.classify.constantize
      rescue NameError
        @controller_name.classify.demodulize.constantize
      end
    end

    def resource_name
      resource_class.model_name.element
    end

    def controller_name(resource)
      resource.model_name.collection
    end

    def var_name(method)
      [method, @controller_name, @action_name, @resource.try(:model_name).try(:human), @resource.try(:id)].compact.map do |s|
        s.to_s.gsub("/", "_").delete("?")
      end.join("_").prepend("@")
    end

    def instance_variable_get_or_set(method)
      @controller.instance_variable_get(var_name(method)) || @controller.instance_variable_set(var_name(method), authorization.send(method))
    end

    def get_controller_and_resource(element, resource)
      if element.is_a? String
        return element, resource
      elsif element.is_a? ActiveRecord::Base
        return controller_name(element), element
      elsif element.is_a? Array
        resource = element.second
        return "#{element.first}/#{controller_name(resource)}", resource
      end
    end

  end

end
