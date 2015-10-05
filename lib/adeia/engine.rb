require "adeia/controller_methods"

module Adeia
  class Engine < ::Rails::Engine
    isolate_namespace Adeia

    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
      g.factory_girl false
    end

    initializer 'Adeia.controller' do |app|
      ActionController::Base.send :include, Adeia::ControllerMethods
    end

  end
end
