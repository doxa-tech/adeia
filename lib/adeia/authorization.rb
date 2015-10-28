require 'adeia/database'
require 'adeia/exceptions'

module Adeia

  class Authorization < Database

    def authorize!
      rights = token_rights(right_name)
      raise LoginRequired if rights[:rights].empty? && @user.nil?
      rights = rights.merge(send("#{right_name}_rights")) { |key, v1, v2| v1 + v2 } if @user
      @rights, @resource_ids = rights[:rights], rights[:resource_ids]
      raise AccessDenied unless @rights.any? && authorize?
    end

    def check_permissions!
      if !@user
        raise LoginRequired
      elsif load_permissions && @rights.empty?
        raise AccessDenied
      end
    end

    def can?
      merge_permissions(token_rights(right_name), send("#{@action}_rights"))
      @rights.any? && authorize?
    end

    private

    def authorize?
      all_entries? || on_ownerships? || on_entry?
    end

    def all_entries?
      @rights.any? { |r| r.permission_type == "all_entries" }
    end

    def on_ownerships?
      @user && @resource && @rights.any? { |r| r.permission_type == "on_ownerships" } && @resource.user == @user
    end

    def on_entry?
      @resource && @resource_ids.include?(@resource.id)
    end

    def right_names
      {read: [:index, :show], create: [:new, :create], update: [:edit, :update], destroy: [:destroy]} 
    end

    def right_name
      right_names.select { |k, v| v.include? @action.to_sym }.keys[0] || :action
    end

    def load_permissions
      merge_permissions(token_rights(right_name), send("#{right_name}_rights"))
    end

    def merge_permissions(collection1, collection2)
      rights = collection1.merge(collection2) { |key, v1, v2| v1 + v2 }
      @rights, @resource_ids = rights[:rights], rights[:resource_ids]
    end

  end

end