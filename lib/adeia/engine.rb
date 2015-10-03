require "adeia/controller_methods"

module Adeia
  class Engine < ::Rails::Engine
    isolate_namespace Adeia

    initializer 'Adeia.controller' do |app|
      ActionController::Base.send :include, Adeia::ControllerMethods
    end

  end
end
