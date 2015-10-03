require 'adeia/authorization'
require 'adeia/exceptions'

module Adeia

  class ControllerResource

    def self.add_before_filter(controller_class, method, **args)
      controller_class.send(:before_action, args.slice(:only, :except, :if, :unless)) do |controller|
        ControllerResource.send(method)
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
      rescue KeyError
        raise MissingParams.new(:id)
      end
    end

    def load_records
      rights = authorization.read_rights + authorization.token_rights
      resource_ids = rights.pluck(:resource_id).compact
      @records ||= if rights.any? { |r| r.permission_type == "all_entries" }
        resource_class.all
      elsif rights.any? { |r| r.permission_type == "on_ownerships" }
        resource_class.where(user_id: @user.id, id: resource_ids)
      elsif rights.any? { |r| r.permission_type == "on_entry" }
        resource_class.where(id: resource_ids)
      else
        resource_class.none
      end
    end

    def load_resoure_or_records_and_authorize!
      if @action == "index"
        @controller.set_instance_var("#{resource_name.pluralize}", authorize_and_load_records!)
      else
        @controller.set_instance_var("#{resource_name}", load_and_authorize!)
      end
    end

    def authorization
      @authorization ||= Authorization.new(@controller_name, @action_name, @token, @resource, @user)
    end


    def authorize!
      authorization.authorize!
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