require "adeia/controller_methods"

module Adeia
  class Engine < ::Rails::Engine

    initializer 'Adeia.controller' do |app|
      ActionController::Base.send :include, Adeia::ControllerMethods
    end

  end
end
