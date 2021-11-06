require "adeia/controller_methods"
require "adeia/helpers/sessions_helper"
require "adeia/helpers/user_helper"
require "adeia/exceptions"

module Adeia
  class Engine < ::Rails::Engine
    require 'snaptable'

    isolate_namespace Adeia

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
      g.factory_bot false
    end

    initializer 'Adeia.requirements' do |app|
      begin
        User
        require 'adeia/guest_user'
      rescue NameError
        raise MissingUserModel
      end
    end

    config.to_prepare do
      ActionController::Base.send :include, Adeia::Helpers::SessionsHelper
      ActionController::Base.send :include, Adeia::ControllerMethods
      User.send :include, Adeia::Helpers::UserHelper
    end

  end
end
