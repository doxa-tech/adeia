module Adeia
  class ApplicationController < ActionController::Base
    layout 'adeia/application'

    add_flash_types :success
  end
end
