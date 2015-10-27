require "adeia/controller_methods"
require "adeia/helpers/sessions_helper"

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

    initializer 'Adeia.controller_methods' do |app|
      ActionController::Base.send :include, Adeia::ControllerMethods
    end

    initializer 'Adeia.sessions_helper' do |app|
      ActionController::Base.send :include, Adeia::Helpers::SessionsHelper
    end

  end
end
