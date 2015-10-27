module Adeia
  class ApplicationController < ActionController::Base
    layout 'adeia'

    add_flash_types :success
  end
end
