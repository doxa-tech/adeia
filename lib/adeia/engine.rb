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
      g.factory_girl false
    end

    initializer 'Adeia.requirements' do |app|
      begin
        User
      rescue NameError
        raise MissingUserModel
      end
    end

    initializer 'Adeia.user_addictions' do |app|
      User.send :include, Adeia::Helpers::UserHelper
    end

    initializer 'Adeia.controller_methods' do |app|
      ActionController::Base.send :include, Adeia::ControllerMethods
    end

    initializer 'Adeia.sessions_helper' do |app|
      ActionController::Base.send :include, Adeia::Helpers::SessionsHelper
    end

  end
end
