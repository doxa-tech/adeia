require 'adeia/authorization'
require 'adeia/exceptions'

module Adeia

  class ControllerResource

    def self.add_before_filter(controller_class, method, **args)
      controller_class.send(:before_action, args.slice(:only, :except, :if, :unless)) do |controller|
        ControllerResource.send(method, controller, **args)
      end
    end

    def self.load_resource_or_records_and_authorize(controller, **args)
      case controller.action_name
      when "index"
        controller.authorize_and_load_records!(**args)
      when "show", "edit", "update", "destroy"
        controller.load_and_authorize!(**args)
      else
        controller.authorize!(**args)
      end
    end

    def self.require_login(controller, **args)
      controller.require_login!
    end

    def self.get_controller_and_resource(element, resource)
      if element.is_a? String
        return element, resource
      elsif element.is_a? ActiveRecord::Base
        return controller_name(element), element
      elsif element.is_a? Array
        resource = element.second
        return "#{element.first}/#{controller_name(resource)}", resource
      end
    end

    def initialize(controller, **args)
      @controller = controller
      @action_name = args.fetch(:action, @controller.action_name)
      @controller_name = args.fetch(:controller, @controller.controller_path)
      @token = args.fetch(:token, @controller.request.GET[:token])
      @resource = args[:resource]
      @model = args[:model] || resource_class
      @user = @controller.current_user
      @controller.current_user ||= GuestUser.new # if not signed in but authorized
      @controller.store_location
    end

    def load_resource
      begin
        @resource ||= @model.find(@controller.params.fetch(:id))
        @controller.instance_variable_set("@#{resource_name}", @resource)
      rescue KeyError
        raise MissingParams.new(:id)
      end
    end

    def load_records
      rights = authorization.read_rights.merge(authorization.token_rights(:read)) { |key, v1, v2| v1 + v2 }
      rights, resource_ids = rights[:rights], rights[:resource_ids]
      @records ||= if rights.any? { |r| r.permission_type == "all_entries" }
        @model.all
      elsif rights.any? { |r| r.permission_type == "on_ownerships" }
        @model.where("user_id = ? OR id IN (?)", @user.id, resource_ids)
      elsif rights.any? { |r| r.permission_type == "on_entry" }
        @model.where(id: resource_ids)
      else
        @model.none
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

    def authorized?(method)
      @controller.instance_variable_get(var_name(method)) || @controller.instance_variable_set(var_name(method), authorization.send(method))
    end

    private

    def resource_class
      if @resource
        @resource.class
      else
        begin
          @controller_name.classify.constantize
        rescue NameError
          begin
            @controller_name.classify.demodulize.constantize
          rescue NameError
            nil
          end
        end
      end
    end

    def resource_name
      @model.model_name.element
    end

    def var_name(method)
      [method, @controller_name, @action_name, @resource.try(:model_name).try(:human), @resource.try(:id)].compact.map do |s|
        s.to_s.gsub("/", "_").delete("?")
      end.join("_").prepend("@")
    end

    def self.controller_name(resource)
      resource.model_name.collection
    end

  end

end
